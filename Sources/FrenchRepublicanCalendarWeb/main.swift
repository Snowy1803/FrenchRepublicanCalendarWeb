
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
        div(.style("width: 100%; height: 100%; padding: 10px; font-family: -apple-system, BlinkMacSystemFont, sans-serif")) {
            div(.style("display: flex; flex-direction: column; align-items: flex-start; gap: 10px")) {
                h1(.style("font-size: 2em")) { "Calendrier républicain" }
                
                let frd = FrenchRepublicanDate(date: date)
                
                div(.style("display: flex; flex-direction: row")) {
                    // Left column labels
                    div(.style("display: flex; flex-direction: column; align-items: flex-end; padding: 0 15px; width: 150px")) {
                        div { "Aujourd'hui :" }
                        div { "Grégorien :" }
                        div { "Républicain :" }
                    }
                    // Right column inputs
                    RightColumnInputs(date: $date, frd: frd, inputDateFormatter: inputDateFormatter)
                }
                
                DateDetails(date: frd)
                
                // Settings
                SettingsView(romanYear: $romanYear, variant: $variant, date: date, setDate: setDate)
            }
        }
    }
}

@View
struct RightColumnInputs {
    @Binding var date: Date
    var frd: FrenchRepublicanDate
    var inputDateFormatter: DateFormatter
    
    // Wrapper to set date from non-binding context if needed, but binding is better
    func setDate(_ newDate: Date) {
        date = newDate
        // Trigger side effects via Binding if possible, or just rely on parent's body update?
        // In Elementary, State updates re-render.
        // But we needed to update the Hash.
        // We can attach .onChange equivalent or just do it in the setter.
        // For now, let's duplicate the hash update logic or move it to a shared helper?
        // Ideally we pass a closure `setDate`.
        updateHash(for: newDate)
    }
    
    func updateHash(for date: Date) {
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
        div(.style("display: flex; flex-direction: column; align-items: flex-start")) {
            a(.href("javascript:void(0)"), .style("color: var(--accent-color, #007aff)")) {
                FRCFormat.republicanDate.weekday(.long).day(.preferred).year(.long).format(FrenchRepublicanDate(date: Date()))
            }
            .onClick {
                setDate(Date())
            }
             // DatePicker replacement
            input(.type(.date), .value(inputDateFormatter.string(from: date)))
                .onInput { event in
                    if let value = event.targetValue {
                        if let newDate = inputDateFormatter.date(from: value) {
                            setDate(newDate)
                        }
                    }
                }
            
            // Republican Date Picker
            RepublicanDatePicker(date: Binding(get: {
                MyRepublicanDateComponents(day: frd.components.day!, month: frd.components.month!, year: frd.components.year!)
            }, set: { newComps in
                setDate(newComps.toRep.date)
            }))
        }
    }
}

@View
struct SettingsView {
    @Binding var romanYear: Bool
    @Binding var variant: Int
    var date: Date
    var setDate: (Date) -> Void
    
    var body: some View {
        // Toggle Roman Year
        label {
            if romanYear {
                input(.type(.checkbox), .checked)
                    .onInput { _ in
                         // Checkbox logic needs to handle unchecking too, but onInput triggers on change.
                         // Standard checkbox toggle logic:
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
            
            " "
            "Chiffres romains pour les années"
        }
        
        // Variant Picker
        div {
            "Calendrier "
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
    
    var body: some View {
        h2(.style("font-size: 1.5em")) { FRCFormat.republicanDate.weekday(.long).day(.preferred).year(.long).format(date) }
        
        div(.style("display: flex; flex-direction: row")) {
             // Labels
             div(.style("display: flex; flex-direction: column; align-items: flex-end; padding: 0 15px; width: 150px")) {
                div { "Jour : " }
                div { "Saison :" }
                div { "Décade :" }
                div { "Jour de l'année :" }
                div { "Date abrégée :" }
             }
             
             // Values
             div(.style("display: flex; flex-direction: column; align-items: flex-start")) {
                 a(.href(date.descriptionURL?.absoluteString ?? "#"), .style("text-decoration: underline; color: var(--accent-color, #007aff)")) {
                    date.dayName
                 }
                 
                 div { date.quarter }
                 div { "\(date.components.weekOfYear!)/37" }
                 div { "\(date.dayInYear)/\(date.isYearSextil ? 366 : 365)" }
                 div { FRCFormat.republicanDate.day(.preferred).dayLength(.short).year(.short).format(date) }
             }
        }
    }
}

// Entry Point
let appHandle = Application(ContentView()).mount(in: .body)
