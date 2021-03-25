import Foundation
import TokamakDOM
import FrenchRepublicanCalendarCore

struct TokamakApp: App {
    var body: some Scene {
        WindowGroup("Convertisseur calendrier républicain") {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text(FrenchRepublicanDate(date: Date()).toVeryLongString())
    }
}

TokamakApp.main()
