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
