//
//  PointView.swift
//  BezierCurve
//
//  Created by Семен Никулин on 20.10.16.
//  Copyright © 2016 niksemv. All rights reserved.
//

import UIKit

class PointView: UIView {
    let size: CGFloat = 5
    
    var startPoint: CGPoint
    var endPoint: CGPoint
    
    init(startPoint: CGPoint, endPoint: CGPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        self.backgroundColor = UIColor.clear
        self.center = startPoint
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        UIColor.red.setFill()
        path.fill()

    }
}
