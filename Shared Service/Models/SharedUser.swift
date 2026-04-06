//
//  SharedUser.swift
//  Ava
//
//  Created by Stacey Fitton on 06/04/2026.
//


import Foundation

public struct SharedUser: Codable, Equatable, Sendable {
    public let id: UUID
    public var displayName: String
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        displayName: String,
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.displayName = displayName
        self.updatedAt = updatedAt
    }
}