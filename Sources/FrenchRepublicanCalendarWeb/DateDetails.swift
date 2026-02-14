
import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore

@View
struct DateDetails {
    var date: FrenchRepublicanDate
    
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
                 gregorianFormatter.string(from: date.date)
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
