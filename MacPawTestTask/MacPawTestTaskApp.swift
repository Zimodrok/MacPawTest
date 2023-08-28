import SwiftUI
@main
struct YourApp: App {
    @State var percentage: Float = 50
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(
                    minWidth: 375,
                    minHeight: 667
                )
                .background(Color("BackgroundColor"))
        }
    }
}
