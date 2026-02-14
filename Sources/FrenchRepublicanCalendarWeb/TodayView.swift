
import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore

@View
struct TodayView {
    @Binding var date: Date
    
    var body: some View {
        div(.class("today-display")) {
            a(.href("javascript:void(0)"), .class("today-link")) {
                FRCFormat.republicanDate.weekday(.long).day(.preferred).year(.long).format(FrenchRepublicanDate(date: Date()))
            }
            .onClick {
                date = Date()
            }
        }
    }
}
