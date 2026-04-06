import SwiftUI
// Mock types for preview-only usage. Replace with your project's mocks if they already exist.

struct RootTabView: View {
    //let container: AppContainer
    @Environment(AvaAppContainer.self) private var container
    
    var body: some View {
        TabView {
            NavigationStack {
                AboutMeView(viewModel: AboutMeViewModel(aiService: container.aiService))
            }
            .tabItem { Label("About Me", systemImage: "person.text.rectangle") }

            NavigationStack {
                GatherView(viewModel: GatherViewModel())
            }
            .tabItem { Label("Gather", systemImage: "tray.and.arrow.down") }

            NavigationStack {
                NotificationsView(viewModel: NotificationsViewModel())
            }
            .tabItem { Label("Notifications", systemImage: "bell") }
        }
    }
}

#Preview {
    // Provide a lightweight preview container so the environment can be satisfied
    let previewContainer = AvaAppContainer(
        appGroupID: "group.com.staceyfitton.ava"
    )
    RootTabView()
        .environment( previewContainer)
}
//#if DEBUG
///// Minimal mock implementation used only for previews. If your project already defines mocks,
///// you can remove this and use those instead.
//private struct MockAIService: AIServiceProtocol {
//    func generateAboutMeSummary() async throws -> String { "This is a preview summary." }
//}
//#endif
//
