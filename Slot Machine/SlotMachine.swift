//
//  SlotMachine.swift
//  Slot Machine
//
//  Created by Alex Pirog on 08.05.2021.
//

import UIKit

typealias SpinResult = (indexes: [Int], winCase: WinCase?)

// MARK: - SlotMachine

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

// MARK: - WinCase

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

// MARK: - Slot protocol

protocol SlotRepresentable {
    var slotValue: String { get }
    
    func slotRepresentableView(of size: CGSize) -> UIView
}

// MARK: - Slot realizations

struct EmojiSlot: SlotRepresentable {
    var slotValue: String
    
    func slotRepresentableView(of size: CGSize) -> UIView {
        let view = UILabel()
        view.text = slotValue
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: size.height * 0.6)
        return view
    }
}

struct ImageSlot: SlotRepresentable {
    var slotValue: String
    
    func slotRepresentableView(of size: CGSize) -> UIView {
        let view = UIImageView(frame: CGRect(origin: .zero, size: size.scaled(by: 0.8)))
        view.image = UIImage(named: slotValue)
        view.backgroundColor = view.image == nil ? .red : .clear
        return view
    }
}
