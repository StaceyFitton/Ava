import Foundation
import Observation

@MainActor
@Observable
public final class SharedUserService {
    public private(set) var user: SharedUser?
    public private(set) var lastErrorMessage: String?

    private let store: AppGroupStoreProtocol

    public init(store: AppGroupStoreProtocol) {
        self.store = store
    }

    public func load() {
        do {
            user = try store.loadUser()
            lastErrorMessage = nil
        } catch {
            lastErrorMessage = error.localizedDescription
        }
    }

    public func save(displayName: String) {
        let trimmed = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        do {
            let existingID = user?.id ?? UUID()
            let updatedUser = SharedUser(
                id: existingID,
                displayName: trimmed,
                updatedAt: Date()
            )

            try store.saveUser(updatedUser)
            user = updatedUser
            lastErrorMessage = nil
        } catch {
            lastErrorMessage = error.localizedDescription
        }
    }

    public func clear() {
        do {
            try store.deleteUser()
            user = nil
            lastErrorMessage = nil
        } catch {
            lastErrorMessage = error.localizedDescription
        }
    }

    public func refresh() {
        load()
    }
}
