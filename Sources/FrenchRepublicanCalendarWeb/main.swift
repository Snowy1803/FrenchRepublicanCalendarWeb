
import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore
import JavaScriptKit

@View
struct ContentView {
    @State var date: Date = Date()
    // Generic refresh signal. Toggling this UUID forces SwiftWasm to re-evaluate the view
    // and re-read FrenchRepublicanDateOptions.current
    @State var refreshID = UUID()
    
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
    
    func updateHash(date: Date) {
        let jsDate = JSDate(millisecondsSinceEpoch: date.timeIntervalSince1970 * 1000)
        let y = jsDate.fullYear
        let year: String
        if y < 0 {
             year = "-" + "00000\(-y)".suffix(6)
        } else if y > 9999 {
             year = "+" + "00000\(y)".suffix(6)
        } else {
             year = String("000\(y)".suffix(4))
        }
        let hash = "\(year)-\("0\(jsDate.month + 1)".suffix(2))-\("0\(jsDate.date)".suffix(2))"
        JSObject.global.window.location.hash = JSValue(stringLiteral: hash)
    }
    
    var body: some View {
        div(.class("app-container")) {
            // Header
            h1 { "Calendrier républicain" }
            
            // Re-calculate FRD whenever date OR refreshID changes
            let _ = refreshID // Dependency
            let frd = FrenchRepublicanDate(date: date)
            
            // Card 1: Today
            div(.class("glass-card")) {
                h2 { "Aujourd'hui" }
                TodayView(date: $date)
            }
            
            // Card 2: Decimal Time
            div(.class("glass-card")) {
                h2 { "Temps décimal" }
                DecimalTimeView()
            }
            
            // Card 3: Converter
            div(.class("glass-card")) {
                h2 { "Convertir" }
                ConverterView(date: $date, frd: frd)
            }
            
            // Card 4: Details
            div(.class("glass-card")) {
                h2 { "Détails" }
                DateDetails(date: frd)
            }
            
            // Card 5: Settings
            div(.class("glass-card")) {
                h2 { "Réglages" }
                SettingsView(onChange: {
                    refreshID = UUID()
                })
            }
        }
        .onChange(of: date) { _, newDate in
             updateHash(date: newDate)
        }
    }
}

// Entry Point
let appHandle = Application(ContentView()).mount(in: .body)
