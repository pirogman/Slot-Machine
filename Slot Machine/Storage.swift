//
//  Storage.swift
//  Slot Machine
//
//  Created by Alex Pirog on 09.05.2021.
//

import Foundation

class Storage {
    
    struct Keys {
        static func bankKey(for currency: Currency) -> String {
            return "bank_" + currency.rawValue
        }
        static func betKey(for currency: Currency) -> String {
            return "bet_" + currency.rawValue
        }
    }
    
    static let shared = Storage()
    
    private init() {
        userBank = [:]
        lastBet = [:]
        for c in Currency.allCases {
            userBank[c] = UserDefaults.standard.value(forKey: Keys.bankKey(for: c)) as? Int ?? 100
            lastBet[c] = UserDefaults.standard.integer(forKey: Keys.betKey(for: c))
        }
    }
    
    var userBank: [Currency: Int] {
        didSet {
            for c in userBank.keys {
                UserDefaults.standard.set(userBank[c], forKey: Keys.bankKey(for: c))
            }
        }
    }
    
    var lastBet: [Currency: Int] {
        didSet {
            for c in lastBet.keys {
                UserDefaults.standard.set(lastBet[c], forKey: Keys.betKey(for: c))
            }
        }
    }
    
}
