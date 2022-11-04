//
//  Deck.swift
//  MVVM
//
//  Created by LanceMacBookPro on 11/3/22.
//

import Foundation

struct Deck: Decodable {
    var success: Bool?
    var deck_id: String?
    var cards = [Card]()
    var remaining: Int?
}
