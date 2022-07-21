//
//  Extensions.swift
//  MyFirstFirebaseProject
//
//  Created by Valeria Karon on 7/11/22.
//  Copyright © 2022 Valeria Karon. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    public var width: CGFloat {
        return frame.size.width
    }

    public var height: CGFloat {
        return frame.size.height
    }

    public var top: CGFloat {
        return frame.origin.y
    }

    public var bottom: CGFloat {
        return frame.size.height + frame.origin.y
    }

    public var left: CGFloat {
        return frame.origin.x
    }

    public var right: CGFloat {
        return frame.size.width + frame.origin.x
    }

}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    static func random(from: Int, to: Int) -> CGFloat {
        let delta = to - from
        guard delta >= 0, from >= 0 else { return 100 }
        return CGFloat.random() * CGFloat(delta) + CGFloat(from)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
    
    static func fromUIntText(text: String) -> UIColor {
        let col: UInt = UInt(text) ?? 0
        let red = CGFloat(col >> 16) / 255.0
        let green = CGFloat((col & 0xFFFF) >> 8) / 255.0
        let blue = CGFloat(col & 0x0000FF) / 255.0
        print("\(col >> 16) \((col & 0xFFFF) >> 8) \(col & 0x0000FF)")
        return UIColor(
           red:   red,
           green: green,
           blue:  blue,
           alpha: 1.0
        )
    }
    
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    var toUInt: UInt {
        let red = UInt(coreImageColor.red * 255 + 0.5)
        let green = UInt(coreImageColor.green * 255 + 0.5)
        let blue = UInt(coreImageColor.blue * 255 + 0.5)
        return (red << 16) | (green << 8) | blue
    }
    
    
}
