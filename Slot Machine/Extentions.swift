//
//  Extentions.swift
//  Slot Machine
//
//  Created by Alex Pirog on 08.05.2021.
//

import Foundation
import CoreGraphics

extension CGSize {
    func scaled(by scale: CGFloat) -> CGSize {
        return CGSize(width: width * scale, height: height * scale)
    }
}
