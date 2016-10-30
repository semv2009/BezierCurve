//
//  ShapeView.swift
//  BezierCurve
//
//  Created by Семен Никулин on 20.10.16.
//  Copyright © 2016 niksemv. All rights reserved.
//

import UIKit

protocol ShapeViewDelegate: class{
    func shapeView(didRemoveView view: ShapeView)
    func shapeView(didMove view: ShapeView)
}

class ShapeView: UIView {
    let size: CGFloat = 30
    let lineWidth: CGFloat = 4
    
    var delegate: ShapeViewDelegate?
    
     var prevPath: Path?
     var nextPath: Path?
    
    init(origin: CGPoint) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        self.center = origin
        self.backgroundColor = UIColor.clear
        initPanGestureRecognizer()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPanGestureRecognizer() {
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        addGestureRecognizer(panGR)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGR)
    }
    
    func didTap(gesture: UIGestureRecognizer) {
        delegate?.shapeView(didRemoveView: self)
    }
    
    func didPan(gesture: UIPanGestureRecognizer) {
        guard let superview = self.superview else { fatalError("Super View doen't init") }
        superview.bringSubview(toFront: self)
        let translation = gesture.translation(in: self)
        self.center.x += translation.x
        self.center.y += translation.y
        gesture.setTranslation(CGPoint.zero, in: self)
        delegate?.shapeView(didMove: self)
    }
    
    override func draw(_ rect: CGRect) {
        let insetRect = rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        let path = UIBezierPath(roundedRect: insetRect, cornerRadius: 20)
        
        UIColor.red.setFill()
        path.fill()
        
        path.lineWidth = self.lineWidth
        UIColor.randomColor().setStroke()
        path.stroke()
    }
}
