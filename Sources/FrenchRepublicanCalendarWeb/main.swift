
import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore
import JavaScriptKit

@View
struct ContentView {
    @State var romanYear: Bool = FrenchRepublicanDateOptions.current.romanYear
    @State var variant: Int = FrenchRepublicanDateOptions.current.variant.rawValue
    @State var date: Date = Date()
    
    // Helper formatter for the date input
    var inputDateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }
    
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
    
    func setDate(_ newDate: Date) {
        date = newDate
        
        let jsDate = JSDate(millisecondsSinceEpoch: newDate.timeIntervalSince1970 * 1000)
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
            
            let frd = FrenchRepublicanDate(date: date)
            
            // Card 1: Today
            div(.class("glass-card"), .class("card-center")) {
                h2 { "Aujourd'hui" }
                div(.class("today-display")) {
                    a(.href("javascript:void(0)"), .class("today-link")) {
                        FRCFormat.republicanDate.weekday(.long).day(.preferred).year(.long).format(FrenchRepublicanDate(date: Date()))
                    }
                    .onClick {
                        setDate(Date())
                    }
                }
            }
            
            // Card 2: Converter
            div(.class("glass-card")) {
                h2 { "Convertisseur" }
                div(.class("converter-grid")) {
                    // Row 1: Gregorian
                    label(.class("converter-label")) { "Grégorien :" }
                    input(.type(.date), .value(inputDateFormatter.string(from: date)))
                        .onInput { event in
                            if let value = event.targetValue {
                                if let newDate = inputDateFormatter.date(from: value) {
                                    setDate(newDate)
                                }
                            }
                        }
                    
                    // Row 2: Republican
                    label(.class("converter-label")) { "Républicain :" }
                    RepublicanDatePicker(date: Binding(get: {
                        MyRepublicanDateComponents(day: frd.components.day!, month: frd.components.month!, year: frd.components.year!)
                    }, set: { newComps in
                        setDate(newComps.toRep.date)
                    }))
                }
            }
            
            // Card 3: Details
            div(.class("glass-card")) {
                h2 { "Détails" }
                DateDetails(date: frd, originalDate: date)
            }
            
            // Card 4: Settings
            div(.class("glass-card")) {
                h2 { "Réglages" }
                SettingsView(romanYear: $romanYear, variant: $variant, date: date, setDate: setDate)
            }
        }
    }
}

// RightColumnInputs removed as it is now integrated into ContentView


@View
struct SettingsView {
    @Binding var romanYear: Bool
    @Binding var variant: Int
    var date: Date
    var setDate: (Date) -> Void
    
    var body: some View {
        div(.class("settings-grid")) {
             // Row 1: Roman Year
            label(.class("settings-label")) { "Années :" }
            div(.class("settings-value-row")) {
                if romanYear {
                    input(.type(.checkbox), .checked)
                        .onInput { _ in
                             romanYear.toggle()
                             updateOptions()
                        }
                } else {
                     input(.type(.checkbox))
                        .onInput { _ in
                             romanYear.toggle()
                             updateOptions()
                        }
                }
                span { "Chiffres romains" }
            }
            
            // Row 2: Variant Picker
            label(.class("settings-label")) { "Calendrier :" }
            select {
                for variantOption in FrenchRepublicanDateOptions.Variant.allCases {
                    if variant == variantOption.rawValue {
                         option(.value("\(variantOption.rawValue)"), .selected) { variantOption.description }
                    } else {
                         option(.value("\(variantOption.rawValue)")) { variantOption.description }
                    }
                }
            }
            .onInput { event in
                if let val = event.targetValue, let intVal = Int(val) {
                    variant = intVal
                     // Save to options
                     var options = FrenchRepublicanDateOptions.current
                     options.variant = FrenchRepublicanDateOptions.Variant(rawValue: variant) ?? .original
                     FrenchRepublicanDateOptions.current = options
                     // Force refresh
                     setDate(date)
                }
            }
        }
    }
    
    func updateOptions() {
         var options = FrenchRepublicanDateOptions.current
         options.romanYear = romanYear
         FrenchRepublicanDateOptions.current = options
         // Force date refresh to apply formatting
         setDate(date)
    }
}

@View
struct DateDetails {
    var date: FrenchRepublicanDate
    var originalDate: Date
    
    var gregorianFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .none
        f.locale = Locale(identifier: "fr_FR")
        return f
    }
    
    var body: some View {
        div(.class("date-details-grid")) {
             // Row 0: Full Date
             div(.class("detail-label")) { "Date complète :" }
             div(.class("detail-value")) {
                 FRCFormat.republicanDate.weekday(.long).day(.preferred).year(.long).format(date)
             }
             
             // Row 0.5: Gregorian Date
             div(.class("detail-label")) { "Date grégorienne :" }
             div(.class("detail-value")) {
                 gregorianFormatter.string(from: originalDate)
             }

             // Row 1
             div(.class("detail-label")) { "Jour :" }
             div(.class("detail-value")) {
                 date.dayName
                 if let url = date.descriptionURL?.absoluteString {
                     a(.href(url), .target(.blank), .class("definition-link")) { "(Définition)" }
                 }
             }
             
             // Row 2
             div(.class("detail-label")) { "Saison :" }
             div(.class("detail-value")) { date.quarter }
             
             // Row 3
             div(.class("detail-label")) { "Décade :" }
             div(.class("detail-value")) { "\(date.components.weekOfYear!)/37" }
             
             // Row 4
             div(.class("detail-label")) { "Jour de l'année :" }
             div(.class("detail-value")) { "\(date.dayInYear)/\(date.isYearSextil ? 366 : 365)" }
             
             // Row 5
             div(.class("detail-label")) { "Date abrégée :" }
             div(.class("detail-value")) { date.toShortenedString() }
        }
    }
}

// Entry Point
let appHandle = Application(ContentView()).mount(in: .body)
