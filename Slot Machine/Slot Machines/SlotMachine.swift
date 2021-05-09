//
//  SlotMachine.swift
//  Slot Machine
//
//  Created by Alex Pirog on 08.05.2021.
//

import Foundation

typealias SpinResult = (indexes: [Int], winCase: WinCase?)

struct SlotMachine {
    
    let machineName: String
    let betStep: Int
    let columns: Int
    let slots: [SlotRepresentable]
    let winCases: [WinCase]
    
    private(set) var currentIndexes = [Int]()
    
    var currentSlots: [SlotRepresentable] {
        var current = [SlotRepresentable]()
        for i in currentIndexes {
            current.append(slots[i])
        }
        return current
    }
    
    init(machineName: String, betStep: Int, columns: Int, slots: [SlotRepresentable], winCases: [WinCase]) {
        self.machineName = machineName
        self.betStep = betStep
        self.columns = columns
        self.slots = slots
        self.winCases = winCases
        for _ in 0..<columns {
            currentIndexes.append(Int.random(in: 0..<slots.count))
        }
    }
    
    mutating func spin() -> SpinResult {
        for i in 0..<columns {
            currentIndexes[i] = Int.random(in: 0..<slots.count)
        }
        return (currentIndexes, checkCases())
    }
    
    private func checkCases() -> WinCase? {
        var best: WinCase?
        for win in winCases {
            if win.check(currentSlots) {
                if best == nil {
                    best = win
                } else if best!.rate < win.rate {
                    best = win
                }
            }
        }
        return best
    }
    
}
