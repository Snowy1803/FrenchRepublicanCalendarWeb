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
        HTML("div", ["style": "width: 100%; height: 100%; padding: 10px;"]) {
            VStack(alignment: .leading) {
                Text("Calendrier républicain").font(.largeTitle)
                HStack {
                    Text("Aujourd'hui :")
                    Spacer()
                    Text(FrenchRepublicanDate(date: Date()).toVeryLongString())
                }
                HStack {
                    Text("Grégorien :")
                    Spacer()
                    DatePicker("", selection: $date, in: FrenchRepublicanDate.safeRange, displayedComponents: [.date])
                }
                HStack {
                    Text("Républicain :")
                    Spacer()
                    let frd = FrenchRepublicanDate(date: date)
                    RepublicanDatePicker(date: Binding {
                        MyRepublicanDateComponents(day: frd.components.day!, month: frd.components.month!, year: frd.components.year!)
                    } set: {
                        date = $0.toRep.date
                    })
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
