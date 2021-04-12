import Foundation
import TokamakDOM
import FrenchRepublicanCalendarCore
import JavaScriptKit

struct TokamakApp: App {
    var body: some Scene {
        WindowGroup("Convertisseur calendrier républicain") {
            ContentView()
        }
    }
}

struct ContentView: View {
    @AppStorage("frdo-roman") var romanYear = false
    @AppStorage("frdo-variant") var variant = 0
    @State private var date: Date = Date()
    
    init() {
        if let str = JSObject.global.window.location.hash.jsString {
            let current = JSDate()
            let components = str.description.dropFirst().components(separatedBy: "-")
            if components.count == 3 {
                current.fullYear = Int(components[0]) ?? 0
                current.month = (Int(components[1]) ?? 0) - 1
                current.date = Int(components[2]) ?? 0
            }
            let ms = current.valueOf()
            if ms.isFinite {
                _date = State(wrappedValue: Date(timeIntervalSince1970: ms / 1000))
            }
        }
    }
    
    func updateFragment() {
        let date = JSDate(millisecondsSinceEpoch: self.date.timeIntervalSince1970 * 1000)
        let y = date.fullYear
        let year: String
        if y < 0 {
            year = "-" + "00000\(-y)".suffix(6)
        } else if y > 9999 {
            year = "+" + "00000\(y)".suffix(6)
        } else {
            year = String("000\(y)".suffix(4))
        }
        print("\(year)-\("0\(date.month + 1)".suffix(2))-\("0\(date.date)".suffix(2))")
        JSObject.global.window.location.hash = JSValue(stringLiteral: "\(year)-\("0\(date.month + 1)".suffix(2))-\("0\(date.date)".suffix(2))")
    }
    
    var body: some View {
        let _ = updateFragment()
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
                Toggle(isOn: $romanYear) {
                    Text("Chiffres romains pour les années")
                }
                Picker(selection: $variant, label: Text("Calendrier")) {
                    AnyView(
                        ForEach(FrenchRepublicanDateOptions.Variant.allCases.map { $0.rawValue }, id: \.self) { variantRaw in
                            let variant = FrenchRepublicanDateOptions.Variant.init(rawValue: variantRaw)!
                            Text(variant.description)
                        }
                    )
                }
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
