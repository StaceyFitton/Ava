//
//  AppGroupStoreProtocol.swift
//  Ava
//
//  Created by Stacey Fitton on 06/04/2026.
//


import Foundation

public protocol AppGroupStoreProtocol: Sendable {
    func loadUser() throws -> SharedUser?
    func saveUser(_ user: SharedUser) throws
    func deleteUser() throws
}