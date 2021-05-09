//
//  SlotsManager.swift
//  Slot Machine
//
//  Created by Alex Pirog on 09.05.2021.
//

import Foundation

struct SlotsManager {
    
    static let skyCurrency: Currency = .stars
    
    static let skyMachine: SlotMachine = {
        let rainbow = EmojiSlot(slotValue: "🌈")
        let sun = EmojiSlot(slotValue: "☀️")
        let cloud = EmojiSlot(slotValue: "☁️")
        let rain = EmojiSlot(slotValue: "🌧")
        let slots = [
            rainbow, sun, sun, cloud, cloud, cloud, rain, rain, rain, rain
        ]
        let cases = [
            WinCase(requiredSlot: rainbow, times: 3, rate: 24),
            WinCase(requiredSlot: sun, times: 3, rate: 12),
            WinCase(requiredSlot: cloud, times: 3, rate: 8),
            WinCase(requiredSlot: rain, times: 3, rate: 6)
        ]
        return SlotMachine(machineName: "Clear Skies", betStep: 10, columns: 3, slots: slots, winCases: cases)
    }()
    
    static let fruitCurrency: Currency = .gems
    
    static let fruitMachine: SlotMachine = {
        let apple = ImageSlot(slotValue: "apple")
        let cherry = ImageSlot(slotValue: "cherry")
        let bananas = ImageSlot(slotValue: "bananas")
        let peach = ImageSlot(slotValue: "peach")
        let pear = ImageSlot(slotValue: "pear")
        let straw = ImageSlot(slotValue: "strawberry")
        let salad = ImageSlot(slotValue: "fruit-salad")
        let slots = [
            salad,
            apple, apple, peach, peach, peach,
            cherry, cherry, pear, pear, pear,
            bananas, bananas, straw, straw, straw
        ]
        var cases = [
            WinCase(requiredSlot: salad, times: 4, rate: 36),
            
            WinCase(requiredSlot: apple, times: 4, rate: 18),
            WinCase(requiredSlot: cherry, times: 4, rate: 18),
            WinCase(requiredSlot: bananas, times: 4, rate: 18),
            
            WinCase(requiredSlot: peach, times: 4, rate: 12),
            WinCase(requiredSlot: pear, times: 4, rate: 12),
            WinCase(requiredSlot: straw, times: 4, rate: 12),
            
            WinCase(requiredSlot: apple, times: 3, rate: 9),
            WinCase(requiredSlot: cherry, times: 3, rate: 9),
            WinCase(requiredSlot: bananas, times: 3, rate: 9),
            
            WinCase(requiredSlot: peach, times: 3, rate: 6),
            WinCase(requiredSlot: pear, times: 3, rate: 6),
            WinCase(requiredSlot: straw, times: 3, rate: 6),
            
            WinCase(requiredSlots: [apple, apple, peach, peach], rate: 15),
            WinCase(requiredSlots: [apple, apple, pear, pear], rate: 15),
            WinCase(requiredSlots: [apple, apple, straw, straw], rate: 15),
            
            WinCase(requiredSlots: [cherry, cherry, peach, peach], rate: 15),
            WinCase(requiredSlots: [cherry, cherry, pear, pear], rate: 15),
            WinCase(requiredSlots: [cherry, cherry, straw, straw], rate: 15),
            
            WinCase(requiredSlots: [bananas, bananas, peach, peach], rate: 15),
            WinCase(requiredSlots: [bananas, bananas, pear, pear], rate: 15),
            WinCase(requiredSlots: [bananas, bananas, straw, straw], rate: 15),
            
            WinCase(requiredSlots: [peach, peach, pear, pear], rate: 9),
            WinCase(requiredSlots: [straw, straw, pear, pear], rate: 9),
            WinCase(requiredSlots: [peach, peach, straw, straw], rate: 9)
        ]
        for i in 1..<cases.count {
            cases[i].jokerValue = salad.slotValue
        }
        return SlotMachine(machineName: "Tasty Fruits", betStep: 5, columns: 4, slots: slots, winCases: cases)
    }()
}
