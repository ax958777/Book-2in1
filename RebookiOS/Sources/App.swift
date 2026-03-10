import SwiftUI

@main
struct RebookApp: App {
    @State private var environment = AppEnvironment()
    var body: some Scene {
        WindowGroup {
            BooksListView()
                .environment(environment)
        }
    }
}
