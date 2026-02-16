
import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore
import JavaScriptKit

@View
struct ContentView {
    @State var selection: FrenchRepublicanDate = FrenchRepublicanDate(date: Date())
    
    var hashStyle: Date.ISO8601FormatStyle {
        Date.ISO8601FormatStyle(timeZone: FrenchRepublicanDateOptions.current.currentTimeZone)
            .year().month().day()
    }

    func updateHash(date: FrenchRepublicanDate) {
        let hash = date.date.formatted(hashStyle)
        JSObject.global.window.location.hash = JSValue(stringLiteral: hash)
    }
    
    func updateDateFromHash() {
        if let str = JSObject.global.window.location.hash.jsString {
            // Drop the '#' character
            let dateString = String(str.description.dropFirst())
            
            if let date = try? Date(dateString, strategy: hashStyle) {
                selection = FrenchRepublicanDate(date: date)
            }
        }
    }
    
    var body: some View {
        div(.class("app-container")) {
            // Header
            h1 { "Calendrier républicain" }
            
            // Card 1: Today
            div(.class("glass-card")) {
                h2 { "Aujourd'hui" }
                TodayView(selection: $selection)
            }
            
            // Card 2: Decimal Time
            div(.class("glass-card")) {
                h2 { "Temps décimal" }
                DecimalTimeView()
            }
            
            // Card 3: Converter
            div(.class("glass-card")) {
                h2 { "Convertir" }
                ConverterView(selection: $selection)
            }
            
            // Card 4: Details
            div(.class("glass-card")) {
                h2 { "Détails" }
                DateDetails(selection: selection)
            }
            
            // Card 5: Settings
            div(.class("glass-card")) {
                h2 { "Réglages" }
                SettingsView(onChange: {
                    selection = FrenchRepublicanDate(date: selection.date)
                })
            }
        }
        .onChange(of: selection) { _, newSelection in
             updateHash(date: newSelection)
        }
        .onAppear {
            // Initial load
            updateDateFromHash()
            
            // Listen for hash changes (back/forward navigation)
            let onHashChange = JSClosure { _ in
                updateDateFromHash()
                return .undefined
            }
            JSObject.global.window.onhashchange = .object(onHashChange)
        }
    }
}

// Entry Point
let appHandle = Application(ContentView()).mount(in: .body)
