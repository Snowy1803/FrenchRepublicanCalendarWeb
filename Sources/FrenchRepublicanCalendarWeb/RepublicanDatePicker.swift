
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore

@View
struct RepublicanDatePicker {
    @Binding var date: MyRepublicanDateComponents
    
    var body: some View {
        div(.style("display: flex")) {
            NavigatingPicker(
                selection: $date.day,
                range: 1..<(date.month < 13 ? 31 : FrenchRepublicanDateOptions.current.variant.isYearSextil(date.year) ? 7 : 6)
            )
            " "
            NavigatingPicker(
                selection: $date.month,
                range: 1..<14,
                transformer: {
                    FrenchRepublicanDate.allMonthNames[$0 - 1]
                }
            )
            " "
            NavigatingPicker(
                selection: $date.year,
                range: 1..<600,
                transformer: {
                    FrenchRepublicanDate(dayInYear: 1, year: $0).formattedYear
                }
            )
        }
    }
}

@View
struct NavigatingPicker {
    @Binding var selection: Int
    var range: Range<Int>
    var transformer: (Int) -> String = String.init
    
    var body: some View {
        select {
            for value in range {
                if selection == value {
                    option(.value("\(value)"), .selected) { transformer(value) }
                } else {
                    option(.value("\(value)")) { transformer(value) }
                }
            }
        }
        .onInput { event in
            // InputEvent in ElementaryUI wraps the raw event, providing targetValue
            if let value = event.targetValue, let intValue = Int(value) {
                selection = intValue
            }
        }
    }
}

struct MyRepublicanDateComponents {
    var day: Int
    var month: Int
    var year: Int
    
    var toRep: FrenchRepublicanDate {
        return FrenchRepublicanDate(dayInYear: (month - 1) * 30 + day, year: year)
    }
}
