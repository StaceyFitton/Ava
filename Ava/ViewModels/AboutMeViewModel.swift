import Foundation
import Observation

@Observable
final class AboutMeViewModel {
    // Input text the user can edit
    var aboutMeText: String = ""

    // Output from AI summarization
    var summary: String = ""

    // Loading / error state
    var isSummarizing: Bool = false
    var errorMessage: String?

    private let aiService: AIServiceProtocol

    init(aiService: AIServiceProtocol) {
        self.aiService = aiService
    }

    @MainActor
    func load() async {
        // Potentially load from persistence later
    }

    @MainActor
    func summarizeText() async {
        guard !aboutMeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isSummarizing = true
        errorMessage = nil
        do {
            let result = try await aiService.summarize(text: aboutMeText)
            summary = result
        } catch {
            errorMessage = error.localizedDescription
        }
        isSummarizing = false
    }
}

