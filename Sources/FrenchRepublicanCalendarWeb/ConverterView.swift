
import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore

@View
struct ConverterView {
    @Binding var selection: FrenchRepublicanDate
    
    var body: some View {
        div(.class("converter-grid")) {
            // Row 1: Gregorian
            label(.class("converter-label")) { "Grégorien :" }
            DateInput(selection: $selection, date: selection.date)
            
            // Row 2: Republican
            label(.class("converter-label")) { "Républicain :" }
            RepublicanDatePicker(date: Binding(get: {
                MyRepublicanDateComponents(day: selection.components.day!, month: selection.components.month!, year: selection.components.year!)
            }, set: { newComps in
                selection = newComps.toRep
            }))
        }
    }
}

@View
struct DateInput {
    @Binding var selection: FrenchRepublicanDate
    var date: Date // The date value does not get updated without this
    
    // ISO8601 FormatStyle for date input (yyyy-MM-dd)
    var inputFormat: Date.ISO8601FormatStyle {
        Date.ISO8601FormatStyle(timeZone: FrenchRepublicanDateOptions.current.currentTimeZone)
        .year().month().day()
    }

    var body: some View {
        input(.type(.date))
            .bindValue(Binding(get: {
                date.formatted(inputFormat)
            }, set: { newValue in
                if let newDate = try? Date(newValue, strategy: inputFormat) {
                    selection = FrenchRepublicanDate(date: newDate)
                }
            }))
    }
}
