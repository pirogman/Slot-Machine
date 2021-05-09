//
//  SlotRepresentable.swift
//  Slot Machine
//
//  Created by Alex Pirog on 09.05.2021.
//

import UIKit

protocol SlotRepresentable {
    var slotValue: String { get }
    
    func slotRepresentableView(of size: CGSize) -> UIView
}
