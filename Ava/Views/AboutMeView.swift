import SwiftUI

struct AboutMeView: View {
    @State var viewModel: AboutMeViewModel

    var body: some View {
        Form {
            Section("About Me") {
                TextEditor(text: $viewModel.aboutMeText)
                    .frame(minHeight: 160)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.quaternary))
            }

            Section {
                Button {
                    Task { await viewModel.summarizeText() }
                } label: {
                    if viewModel.isSummarizing {
                        ProgressView()
                    } else {
                        Label("Summarize", systemImage: "text.append")
                    }
                }
                .disabled(viewModel.isSummarizing || viewModel.aboutMeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            if let error = viewModel.errorMessage, !error.isEmpty {
                Section("Error") {
                    Text(error).foregroundStyle(.red)
                }
            }

            if !viewModel.summary.isEmpty {
                Section("Summary") {
                    Text(viewModel.summary)
                        .textSelection(.enabled)
                }
            }
        }
        .navigationTitle("About Me")
        .task { await viewModel.load() }
    }
}

#Preview {
    NavigationStack {
        AboutMeView(viewModel: AboutMeViewModel(aiService: MockAIService()))
    }
}
