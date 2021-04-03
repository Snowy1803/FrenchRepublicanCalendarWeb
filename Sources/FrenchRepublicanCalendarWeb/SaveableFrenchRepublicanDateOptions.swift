//
//  SaveableFrenchRepublicanDateOptions.swift
//  
//
//  Created by Emil Pedersen on 03/04/2021.
//

import FrenchRepublicanCalendarCore
import Foundation
import TokamakDOM

extension FrenchRepublicanDateOptions: SaveableFrenchRepublicanDateOptions {
    public static var current: FrenchRepublicanDateOptions {
        get {
            FrenchRepublicanDateOptions(
                romanYear: LocalStorage.standard.read(key: "frdo-roman") ?? false,
                variant: Variant(rawValue: LocalStorage.standard.read(key: "frdo-variant") ?? 0) ?? .original
            )
        }
        set {
            LocalStorage.standard.store(key: "frdo-roman", value: newValue.romanYear)
            LocalStorage.standard.store(key: "frdo-variant", value: newValue.variant.rawValue)
        }
    }
}
