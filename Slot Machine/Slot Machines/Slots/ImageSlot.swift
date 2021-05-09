//
//  ImageSlot.swift
//  Slot Machine
//
//  Created by Alex Pirog on 09.05.2021.
//

import UIKit

struct ImageSlot: SlotRepresentable {
    
    var slotValue: String
    
    func slotRepresentableView(of size: CGSize) -> UIView {
        let view = UIImageView(frame: CGRect(origin: .zero, size: size.scaled(by: 0.8)))
        view.image = UIImage(named: slotValue)
        view.backgroundColor = view.image == nil ? .red : .clear
        return view
    }
    
}
