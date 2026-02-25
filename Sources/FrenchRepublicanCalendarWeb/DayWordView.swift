import Foundation
import Elementary
import ElementaryUI
import FrenchRepublicanCalendarCore

extension FrenchRepublicanDate.DayNameNature {
    var natureDescription: String {
        switch self {
        case .nm:
            return "(nom masculin)"
        case .nf:
            return "(nom féminin)"
        case .nmpl:
            return "(nom masculin pluriel)"
        case .nfpl:
            return "(nom féminin pluriel)"
        }
    }
}

@View
struct DayWordView {
    var selection: FrenchRepublicanDate
    
    var body: some View {
        div(.class("day-word-container")) {
            div(.class("day-name-header")) {
                span(.class("day-name")) {
                    selection.dayName.capitalized
                }
                span(.class("day-nature")) {
                    " " + selection.dayNameGrammaticalNature.natureDescription
                }
            }
            p(.class("day-explanation")) {
                selection.dayNameExplanation
            }
            if let url = selection.descriptionURL?.absoluteString {
                div(.class("definition-link-container")) {
                    a(.href(url), .target(.blank), .class("definition-link-button")) {
                        "Définition en ligne"
                    }
                }
            }
        }
    }
}
