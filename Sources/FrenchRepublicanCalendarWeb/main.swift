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
                let frd = FrenchRepublicanDate(date: date)
                HStack {
                    VStack(alignment: .trailing) {
                        Text("Aujourd'hui :")
                        Text("Grégorien :")
                        Text("Républicain :")
                    }.padding([.leading, .trailing], 15)
                    .frame(width: 150)
                    
                    VStack(alignment: .leading) {
                        DynamicHTML("a", [
                            "href": "javascript:void%200",
                        ], listeners: [
                            "click": { _ in
                                date = Date()
                            }
                        ]) {
                            Text(FrenchRepublicanDate(date: Date()).toVeryLongString())
                                .foregroundColor(.accentColor)
                        }
                        DatePicker("", selection: $date, in: FrenchRepublicanDate.safeRange, displayedComponents: [.date])
                        RepublicanDatePicker(date: Binding {
                            MyRepublicanDateComponents(day: frd.components.day!, month: frd.components.month!, year: frd.components.year!)
                        } set: {
                            date = $0.toRep.date
                        })
                    }
                    Spacer()
                }
                DateDetails(date: frd)
                Spacer()
            }
        }
    }
}

struct DateDetails: View {
    var date: FrenchRepublicanDate
    
    var body: some View {
        Text(date.toVeryLongString()).font(.title2)
        // until we get alignment guides...
        HStack {
            VStack(alignment: .trailing) {
                Text("Jour : ")
                Text("Saison :")
                Text("Décade :")
                Text("Jour de l'année :")
                Text("Date abrégée :")
            }.padding([.leading, .trailing], 15)
            .frame(width: 150)
            
            VStack(alignment: .leading) {
                Link(destination: date.descriptionURL!) {
                    Text(date.dayName)
                        .underline()
                        .foregroundColor(.accentColor)
                }
                Text(date.quarter)
                Text("\(date.components.weekOfYear!)/37")
                Text("\(date.dayInYear)/\(date.isYearSextil ? 366 : 365)")
                Text(date.toShortenedString())
            }
            Spacer()
        }
    }
}

TokamakApp.main()
