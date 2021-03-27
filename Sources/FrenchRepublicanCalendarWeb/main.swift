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
    @State private var date: Date = Date()
    
    var body: some View {
        HTML("div", ["style": "width: 100%; padding: 10px;"]) {
            VStack(alignment: .leading) {
                Text("Calendrier républicain").font(.largeTitle)
                HStack {
                    Text("Hier :")
                    Spacer()
                    Text(FrenchRepublicanDate(date: Date().addingTimeInterval(-3600*24)).toVeryLongString())
                }
                HStack {
                    Text("Aujourd'hui :")
                    Spacer()
                    Text(FrenchRepublicanDate(date: Date()).toVeryLongString())
                }
                HStack {
                    Text("Date :")
                    Spacer()
                    DatePicker("", selection: $date, in: FrenchRepublicanDate.safeRange, displayedComponents: [.date])
                }
                HStack {
                    Spacer()
                    Text(FrenchRepublicanDate(date: date).toVeryLongString())
                }
                Spacer()
            }
        }
    }
}

TokamakApp.main()
