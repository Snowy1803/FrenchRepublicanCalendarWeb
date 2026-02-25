
import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore

@View
struct DateDetails {
    var selection: FrenchRepublicanDate
    
    var body: some View {
        div(.class("form-grid"), .class("date-details-grid")) {
             // Row 0: Full Date
             div(.class("form-label")) { "Date complète :" }
             div(.class("detail-value")) {
                 FRCFormat.republicanDate.weekday(.long).day(.preferred).year(.long).format(selection)
             }
             
             // Row 0.5: Gregorian Date
             div(.class("form-label")) { "Date grégorienne :" }
             div(.class("detail-value")) {
                 selection.date.formatted(
                    Date.FormatStyle(timeZone: FrenchRepublicanDateOptions.current.currentTimeZone)
                    .weekday(.wide).day().month(.wide).year()
                    .locale(Locale(identifier: "fr_FR"))
                 )
             }
             
             // Row 2
             div(.class("form-label")) { "Saison :" }
             div(.class("detail-value")) { selection.quarter }
             
             // Row 3
             div(.class("form-label")) { "Décade :" }
             div(.class("detail-value")) { "\(selection.components.weekOfYear!)/37" }
             
             // Row 4
             div(.class("form-label")) { "Jour de l'année :" }
             div(.class("detail-value")) { "\(selection.dayInYear)/\(selection.isYearSextil ? 366 : 365)" }
             
             // Row 5
             div(.class("form-label")) { "Date abrégée :" }
             div(.class("detail-value")) { selection.toShortenedString() }
        }
    }
}
