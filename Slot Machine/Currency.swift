//
//  Currency.swift
//  Slot Machine
//
//  Created by Alex Pirog on 09.05.2021.
//

import Foundation

enum Currency: String, CaseIterable, Codable {
    case stars = "⭐️"
    case gems = "💎"
    case usd = "$"
    case eur = "€"
}
