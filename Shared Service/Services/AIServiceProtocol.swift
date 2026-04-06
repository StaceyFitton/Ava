//
//  AIServiceProtocol.swift
//  Ava
//
//  Created by Stacey Fitton on 06/04/2026.
//


// Abstraction for AI capabilities backed by Apple Foundation Models.
public protocol AIServiceProtocol {
    func summarize(text: String) async throws -> String
    func generateResponse(to prompt: String) async throws -> String
    func classify(text: String, labels: [String]) async throws -> String
}
