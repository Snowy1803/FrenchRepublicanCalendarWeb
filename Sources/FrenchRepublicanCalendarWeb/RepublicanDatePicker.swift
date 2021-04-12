//
//  RepublicanDatePicker.swift
//  FrenchRepublicanCalendar
//
//  Created by Emil Pedersen on 20/10/2020.
//  Copyright © 2020 Snowy_1803. All rights reserved.
//

//import TokamakDOM
import TokamakCore
import FrenchRepublicanCalendarCore

struct RepublicanDatePicker: View {
    @Binding var date: MyRepublicanDateComponents
    
    var body: some View {
        HStack(spacing: 0) {
            NavigatingPicker(
                selection: $date.day,
                range: 1..<(date.month < 13 ? 31 : date.year % 4 == 3 ? 7 : 6)
            )
            Text(" ")
            NavigatingPicker(
                selection: $date.month,
                range: 1..<14,
                transformer: {
                    FrenchRepublicanDate.allMonthNames[$0 - 1]
                }
            )
            Text(" ")
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

struct NavigatingPicker: View {
    @Binding var selection: Int
    var range: Range<Int>
    var transformer: (Int) -> String = String.init
    
    var body: some View {
        Picker(selection: Binding<Int>(get: { selection - range.startIndex }, set: { selection = $0 + range.startIndex }), label: EmptyView()) {
            AnyView(
                ForEach(range) { value in
                    Text(transformer(value))
                }
            )
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
