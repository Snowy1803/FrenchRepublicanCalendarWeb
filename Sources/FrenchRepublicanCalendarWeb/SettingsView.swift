
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
        div(.class("form-grid"), .class("settings-grid")) {
             // Row 1: Roman Year
            Elementary.label(.class("form-label")) { "Années :" }
            Elementary.label(.class("settings-value-row")) {
                input(.type(.checkbox))
                    .bindChecked(Binding {
                        FrenchRepublicanDateOptions.current.romanYear
                    } set: {
                        FrenchRepublicanDateOptions.current.romanYear = $0
                        onChange()
                    })
                span { "Chiffres romains" }
            }
            
            // Row 2: Variant Picker
            Elementary.label(.class("form-label")) { "Calendrier :" }
            div {
                select {
                    for variantOption in FrenchRepublicanDateOptions.Variant.allCases {
                         option(.value("\(variantOption.rawValue)"), .selected) { variantOption.description }
                            .attributes(.selected, when: FrenchRepublicanDateOptions.current.variant == variantOption)
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
            Elementary.label(.class("form-label"), .class("align-start")) { "Fuseau horaire :" }
            div {
                select {
                    let tzi = FrenchRepublicanDateOptions.timeZoneIdentifier
                    option(.value("local")) { "Heure locale" }
                        .attributes(.selected, when: tzi == "local")
                    option(.value("paris_meridian")) { "Heure moyenne de Paris" }
                        .attributes(.selected, when: tzi == "paris_meridian")
                    option(.value("GMT")) { "Heure de Greenwich" }
                        .attributes(.selected, when: tzi == "GMT")
                    option(.value("Europe/Paris")) { "Heure à Paris" }
                        .attributes(.selected, when: tzi == "Europe/Paris")
                    if timeZoneCaption == "" {
                        option(.value(tzi), .selected) { "Autre : " + tzi }
                    }
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
