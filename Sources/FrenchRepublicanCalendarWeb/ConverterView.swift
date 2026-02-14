
import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore

@View
struct ConverterView {
    @Binding var date: Date
    var frd: FrenchRepublicanDate
    
    // Helper formatter for the date input
    var inputDateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }
    
    var body: some View {
        div(.class("converter-grid")) {
            // Row 1: Gregorian
            label(.class("converter-label")) { "Grégorien :" }
            input(.type(.date), .value(inputDateFormatter.string(from: date)))
                .onInput { event in
                    if let value = event.targetValue {
                        if let newDate = inputDateFormatter.date(from: value) {
                            date = newDate
                        }
                    }
                }
            
            // Row 2: Republican
            label(.class("converter-label")) { "Républicain :" }
            RepublicanDatePicker(date: Binding(get: {
                MyRepublicanDateComponents(day: frd.components.day!, month: frd.components.month!, year: frd.components.year!)
            }, set: { newComps in
                date = newComps.toRep.date
            }))
        }
    }
}
