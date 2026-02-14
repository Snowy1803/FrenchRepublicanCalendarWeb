
import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore
import JavaScriptKit

@View
struct SettingsView {
    // Callback to notify parent of changes
    var onChange: () -> Void
    
    var timeZoneCaption: String {
        switch FrenchRepublicanDateOptions.timeZoneIdentifier {
        case "local": return "Utiliser le fuseau horaire système"
        case "paris_meridian": return "Fuseau utilisé en France entre 1891 et 1911"
        case "GMT": return "Fuseau utilisé en France entre 1911 et 1940"
        case "Europe/Paris": return "Fuseau utilisé en France actuellement"
        default: return ""
        }
    }
    
    var body: some View {
        div(.class("settings-grid")) {
             // Row 1: Roman Year
            Elementary.label(.class("settings-label")) { "Années :" }
            Elementary.label(.class("settings-value-row")) {
                input(attributes: [.type(.checkbox)] + (FrenchRepublicanDateOptions.current.romanYear ? [.checked] : []))
                    .onInput { _ in
                            FrenchRepublicanDateOptions.current.romanYear.toggle()
                            onChange()
                    }
                span { "Chiffres romains" }
            }
            
            // Row 2: Variant Picker
            Elementary.label(.class("settings-label")) { "Calendrier :" }
            div {
                select {
                    for variantOption in FrenchRepublicanDateOptions.Variant.allCases {
                        if FrenchRepublicanDateOptions.current.variant == variantOption {
                             option(.value("\(variantOption.rawValue)"), .selected) { variantOption.description }
                        } else {
                             option(.value("\(variantOption.rawValue)")) { variantOption.description }
                        }
                    }
                }
                .onInput { event in
                    if let val = event.targetValue, let intVal = Int(val), let v = FrenchRepublicanDateOptions.Variant(rawValue: intVal) {
                        FrenchRepublicanDateOptions.current.variant = v
                        onChange()
                    }
                }
            }
            
            // Row 3: TimeZone Picker
            Elementary.label(.class("settings-label"), .class("align-start")) { "Fuseau horaire :" }
            div {
                select {
                    option(.value("local"), FrenchRepublicanDateOptions.timeZoneIdentifier == "local" ? .selected : .class("opt")) { "Heure locale" }
                    option(.value("paris_meridian"), FrenchRepublicanDateOptions.timeZoneIdentifier == "paris_meridian" ? .selected : .class("opt")) { "Heure moyenne de Paris" }
                    option(.value("GMT"), FrenchRepublicanDateOptions.timeZoneIdentifier == "GMT" ? .selected : .class("opt")) { "Heure de Greenwich" }
                    option(.value("Europe/Paris"), FrenchRepublicanDateOptions.timeZoneIdentifier == "Europe/Paris" ? .selected : .class("opt")) { "Heure à Paris" }
                }
                .onInput { event in
                    if let val = event.targetValue {
                        FrenchRepublicanDateOptions.timeZoneIdentifier = val
                        onChange()
                    }
                }
                div(.class("settings-caption")) {
                    timeZoneCaption
                }
            }
        }
    }
}
