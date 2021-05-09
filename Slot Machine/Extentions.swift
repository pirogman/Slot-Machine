//
//  Extentions.swift
//  Slot Machine
//
//  Created by Alex Pirog on 08.05.2021.
//

import UIKit

extension CGSize {
    func scaled(by scale: CGFloat) -> CGSize {
        return CGSize(width: width * scale, height: height * scale)
    }
}

extension TimeInterval {
    static let minute: TimeInterval = 60
    static let hour: TimeInterval = minute * 60
}
