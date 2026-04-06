//
//  AppGroupStore.swift
//  Ava
//
//  Created by Stacey Fitton on 06/04/2026.
//


import Foundation

public enum AppGroupStoreError: LocalizedError {
    case containerUnavailable(String)

    public var errorDescription: String? {
        switch self {
        case .containerUnavailable(let groupID):
            return "Unable to access App Group container for \(groupID)."
        }
    }
}

public final class AppGroupStore: AppGroupStoreProtocol, @unchecked Sendable {
    private let appGroupID: String
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(
        appGroupID: String,
        fileManager: FileManager = .default
    ) {
        self.appGroupID = appGroupID
        self.fileManager = fileManager

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    private var containerURL: URL {
        get throws {
            guard let url = fileManager.containerURL(
                forSecurityApplicationGroupIdentifier: appGroupID
            ) else {
                throw AppGroupStoreError.containerUnavailable(appGroupID)
            }
            return url
        }
    }

    private var userFileURL: URL {
        get throws {
            try containerURL.appendingPathComponent("shared-user.json")
        }
    }

    public func loadUser() throws -> SharedUser? {
        let fileURL = try userFileURL

        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }

        let data = try Data(contentsOf: fileURL)
        return try decoder.decode(SharedUser.self, from: data)
    }

    public func saveUser(_ user: SharedUser) throws {
        let fileURL = try userFileURL
        let data = try encoder.encode(user)
        try data.write(to: fileURL, options: .atomic)
    }

    public func deleteUser() throws {
        let fileURL = try userFileURL

        guard fileManager.fileExists(atPath: fileURL.path) else {
            return
        }

        try fileManager.removeItem(at: fileURL)
    }
}
