
import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore
import JavaScriptKit

@View
struct TodayView {
    @Binding var selection: FrenchRepublicanDate
    
    var body: some View {
        let today = FrenchRepublicanDate(date: Date())
        div(.class("today-date-layout")) {
            let _ = selection // force update on settings change
            
            // Left part: Large day number
            div(.class("today-day-number")) {
                String(today.components.day ?? 0)
            }
            
            // Right part: Stacked Month+Year and Day Name
            div(.class("today-date-details")) {
                div(.class("today-month-year")) {
                    FRCFormat.republicanDate.day(.monthOnly).year(.long).format(today)
                }
                div(.class("today-day-name")) {
                    FRCFormat.republicanDate.day(.dayName).dayLength(.long).format(today)
                    
                    a(.href("javascript:void(0)"), .class("definition-link")) { "(Définition)" }
                    .onClick {
                        selection = today
                        // Scroll to the Word of the Day card
                        let document = JSObject.global.document
                        let elementToScroll = document.getElementById("word-of-the-day")
                        
                        if elementToScroll.object != nil {
                            let options = JSObject.global.Object.function!.new([
                                "behavior": "smooth",
                                "block": "start"
                            ])
                            _ = elementToScroll.scrollIntoView(options)
                        }
                    }
                }
            }
        }
    }
}
