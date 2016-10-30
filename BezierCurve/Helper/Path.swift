//
//  Path.swift
//  BezierCurve
//
//  Created by Семен Никулин on 26.10.16.
//  Copyright © 2016 niksemv. All rights reserved.
//

import Foundation
import UIKit

class Path {
    weak var toPoint: ShapeView?
    weak var path: CAShapeLayer?
    
    init(toPoint: ShapeView, path: CAShapeLayer) {
        self.path = path
        self.toPoint = toPoint
    }
}
