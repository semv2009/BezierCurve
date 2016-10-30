//
//  UIColor+Random Color.swift
//  BezierCurve
//
//  Created by Семен Никулин on 21.10.16.
//  Copyright © 2016 niksemv. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func randomColor() -> UIColor {
        let hue: CGFloat = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        return UIColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 1)
    }
}
