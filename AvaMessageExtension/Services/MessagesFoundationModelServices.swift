//
//  MessagesFoundationModelServices.swift
//  Ava
//
//  Created by Stacey Fitton on 06/04/2026.
//
import Foundation
import FoundationModels

enum ExecutionMethod {
    case stream
    case wait
}

enum ResponseType {
    case    generatedObject
    case    plainText
}
   



@Generable(description: "Set of multiple responses to the prompt" )
struct ResponseList {
    @Guide(description: "array with all reponses ")
    var responses: [String]
    
    @Guide(description: "ISO 8601 date string of when the response was created ")
    var createdAt: String
}

enum MessagesFoundationModelsServiceError: LocalizedError {
    case unavailable(SystemLanguageModel.Availability)
    case unsupportedLocale

    var errorDescription: String? {
        switch self {
        case .unavailable(let availability):
            return "The on-device model is unavailable: \(String(describing: availability))."
        case .unsupportedLocale:
            return "The current language or locale is not supported by the on-device model."
        }
    }
}

// Concrete implementation placeholder. Replace internals with real Foundation Models calls.
public final class MessagesFoundationModelsService: AIServiceProtocol {
    
    public var isResponding: Bool = false

    let prompt :String = ""
    private let executionMethod: ExecutionMethod = .wait
    private let reponseType :ResponseType = .generatedObject
    private let model = SystemLanguageModel.default
    
    private let instructions = "your name is Leah and you are helping to create friendly responses to texts that are received from friends, who are typically about 16 years old. please respond wth 5 or fewer options to select from, each on a new line."
    
    private var streamingTask: Task<Void, Never>?
    private lazy var session = LanguageModelSession(instructions: instructions)
    
    
    public init() {}
    public func summarize(text: String) async throws -> String {
        // TODO: Integrate with Apple Foundation Models summarization API
        // For now, return a stubbed summary.
        var x = 100;
        x = x+1
        return "[FM] Summary: \(text.prefix(80))…"
    }

    public func generateResponseOptions(to prompt: String) async throws -> [String] {
        self.isResponding = true
        defer { self.isResponding = false }

        let availability = model.availability
        guard case .available = availability else {
            throw MessagesFoundationModelsServiceError.unavailable(availability)
        }

        guard model.supportsLocale() else {
            throw MessagesFoundationModelsServiceError.unsupportedLocale
        }

        do {
//            let localLLMResponse: LanguageModelSession.Response<ResponseList> = try await session.respond(to: prompt, generating: ResponseList.self)
//            return localLLMResponse.content.responses
            _ = try await session.respond(to: "Reply with exactly: OK")
            
            return ["Check1 " , "Check2" , "Check3" , "Check4" , "Check5"]
        } catch is CancellationError {
            print("Cancelled:")
            throw CancellationError()
        } catch {
            print("Error:", error)
            throw error
        }
    }
    
//    public func generateResponse(for input: String, completion: @escaping (Result<[String], any Error>) -> Void) async {
//        self.isResponding = true
//        do {
//            let localLLMResponse :LanguageModelSession.Response<ResponseList> = try await session.respond(to: prompt, generating: ResponseList.self)
//            let listOfResponses : ResponseList = localLLMResponse.content
//            completion(.success(listOfResponses.responses))
//
//        } catch is CancellationError {
//            completion(.failure(CancellationError()))
//        } catch {
//            print("Error:", error)
//            completion(.failure(error))
//        }
//        self.isResponding = false
//    }

    public func classify(text: String, labels: [String]) async throws -> String {
        // TODO: Integrate with Apple Foundation Models classification API
        return labels.randomElement() ?? "unknown"
    }
}
