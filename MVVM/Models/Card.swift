//
//  Card.swift
//  MVVM
//
//  Created by LanceMacBookPro on 11/3/22.
//

import Foundation

struct Card: Decodable {
    var code: String?
    var image: String?
    var images: CardImages?
    var value: String?
    var suit: String?
}
