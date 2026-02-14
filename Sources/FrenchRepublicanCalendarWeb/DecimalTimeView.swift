
import Foundation
import Elementary
import ElementaryUI
import JavaScriptKit
import FrenchRepublicanCalendarCore

@View
struct DecimalTimeView {
    @State var time = DecimalTime()
    @State var timer: JSValue? = nil
    
    var body: some View {
        div(.class("decimal-time-display")) {
            "\(time.description)"
            span(.class("decimal-fraction")) {
                String(format: "%.1f", time.remainder).dropFirst()
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    func startTimer() {
        stopTimer()
        timer = JSObject.global.setInterval!(JSClosure { [self] _ in
            time = DecimalTime()
            return JSValue.null
        }, 86)
    }
    
    func stopTimer() {
        if let t = timer {
            _ = JSObject.global.clearInterval!(t)
            timer = nil
        }
    }
}
