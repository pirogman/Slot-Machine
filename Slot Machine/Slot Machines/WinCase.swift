//
//  WinCase.swift
//  Slot Machine
//
//  Created by Alex Pirog on 09.05.2021.
//

import Foundation

struct WinCase {
    
    let requiredValues: [String]
    let rate: Int
    var jokerValue: String?
    
    init(requiredValues: [String], rate: Int) {
        self.requiredValues = requiredValues
        self.rate = rate
    }
    
    init(requiredValue value: String, times: Int, rate: Int) {
        self.requiredValues = Array(repeating: value, count: times)
        self.rate = rate
    }
    
    init(requiredSlots slots: [SlotRepresentable], rate: Int) {
        self.requiredValues = slots.map { $0.slotValue }
        self.rate = rate
    }
    
    init(requiredSlot slot: SlotRepresentable, times: Int, rate: Int) {
        self.requiredValues = Array(repeating: slot.slotValue, count: times)
        self.rate = rate
    }
    
    func check(_ slots: [SlotRepresentable]) -> Bool {
        var slotsToCheck = requiredValues
        for slot in slots {
            if let index = slotsToCheck.firstIndex(of: slot.slotValue) {
                slotsToCheck.remove(at: index)
            }
        }
        if let joker = jokerValue, !slotsToCheck.isEmpty {
            return slotsToCheck.count == slots.filter { $0.slotValue == joker }.count
        }
        return slotsToCheck.isEmpty
    }
    
}
