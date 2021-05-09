//
//  EmojiSlot.swift
//  Slot Machine
//
//  Created by Alex Pirog on 09.05.2021.
//

import UIKit

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
