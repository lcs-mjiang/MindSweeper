import SwiftUI
import SwiftUI
import SwiftData

@main
struct MindSweeperApp: App {
    @State private var gameState = GameState()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(gameState)
        }
        // Creates the local SQLite database automatically
        .modelContainer(for: CustomDeck.self)
    }
}
