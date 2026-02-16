
import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore

@View
struct TodayView {
    @Binding var selection: FrenchRepublicanDate
    
    var body: some View {
        let today = FrenchRepublicanDate(date: Date())
        div(.class("today-display")) {
            let _ = selection // mark as used, to force update when settings change
            a(.href("javascript:void(0)"), .class("today-link")) {
                FRCFormat.republicanDate.weekday(.long).day(.preferred).year(.long).format(today)
            }
            .onClick {
                selection = today
            }
        }
    }
}
