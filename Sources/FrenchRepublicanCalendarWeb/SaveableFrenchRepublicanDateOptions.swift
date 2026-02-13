//
//  SaveableFrenchRepublicanDateOptions.swift
//  FrenchRepublicanCalendarWeb
//
//  Created by Emil Pedersen on 03/04/2021.
//  Copyright © 2021 Snowy_1803. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import FrenchRepublicanCalendarCore
import Foundation
import FrenchRepublicanCalendarCore
import Foundation
import JavaScriptKit

extension FrenchRepublicanDateOptions: @retroactive SaveableFrenchRepublicanDateOptions {
    public static var current: FrenchRepublicanDateOptions {
        get {
            let storage = JSObject.global.localStorage
            let romanYear = storage.getItem("frdo-roman").string == "true"
            let variantString = storage.getItem("frdo-variant").string ?? "2" // Default to Delambre (2)
            let variantRaw = Int(variantString) ?? 2
            
            return FrenchRepublicanDateOptions(
                romanYear: romanYear,
                variant: Variant(rawValue: variantRaw) ?? .delambre
            )
        }
        set {
            let storage = JSObject.global.localStorage
            _ = storage.setItem("frdo-roman", JSValue.boolean(newValue.romanYear))
            _ = storage.setItem("frdo-variant", JSValue.string(String(newValue.variant.rawValue)))
        }
    }
}
