import Foundation

@MainActor
@Observable
public final class AvaAppContainer {
    public let sharedUserService: SharedUserService
    public let aiService: AIServiceProtocol
    
    public init(appGroupID: String) {
        let store = AppGroupStore(appGroupID: appGroupID)
        self.sharedUserService = SharedUserService(store: store)
        self.aiService = AvaFoundationModelsService()
    }
}

// MARK: - Mock for previews/tests
struct MockAIService: AIServiceProtocol {
    func summarize(text: String) async throws -> String {
        return "Summary: \(text.prefix(40))…"
    }

    func generateResponseOptions(to prompt: String) async throws -> [String] {
        return ["Generated responses to: \(prompt)"]
    }

    func classify(text: String, labels: [String]) async throws -> String {
        return labels.first ?? "unknown"
    }
}
