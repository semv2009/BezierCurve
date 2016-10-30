//
//  BezierPath.swift
//  BezierCurve
//
//  Created by Семен Никулин on 21.10.16.
//  Copyright © 2016 niksemv. All rights reserved.
//

import Foundation
import UIKit

class BezierPath {
    
    weak var contentView: UIView?
    
    var shapeViews = [ShapeView]()
    var beziePath = [PointView]()
    
    init(view: UIView) {
        self.contentView = view
    }
    
    func appendView(point: CGPoint) {
        let shapeView = ShapeView(origin: point)
        shapeView.delegate = self
        shapeViews.append(shapeView)
        self.contentView?.addSubview(shapeView)
        
        if shapeViews.count > 1 {
            let prevIndex = shapeViews.count - 2
            let line = createdPath(from: shapeView.center, to: shapeViews[prevIndex].center)
            shapeView.prevPath = Path(toPoint: shapeViews[prevIndex], path: line)
            shapeViews[prevIndex].nextPath = Path(toPoint: shapeView, path: line)
        }
    }
    
    func startBezie() {
        clearPath()
        if shapeViews.count > 1 {
            bezie(points: shapeViews.map({$0.center}))
        }
    }
    
    func createdPath(from fromPoint: CGPoint, to toPoint: CGPoint) -> CAShapeLayer {
        let linePath = UIBezierPath()
        linePath.move(to: fromPoint)
        linePath.addLine(to: toPoint)
        let line = CAShapeLayer()
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.strokeColor = UIColor.red.cgColor
        contentView?.layer.addSublayer(line)
        return line
    }
    
    func updatePaths(view: ShapeView) {
        if let prev = view.prevPath {
            prev.path?.removeFromSuperlayer()
            view.prevPath?.path = nil
            guard let prevPoint = prev.toPoint else { return }
            let line =  createdPath(from: view.center, to: prevPoint.center)
            prev.path = line
            view.prevPath?.toPoint?.nextPath?.path = line
        }
        
        if let next = view.nextPath {
            next.path?.removeFromSuperlayer()
            view.nextPath?.path = nil
            guard let nextPoint = next.toPoint else { return }
            let line = createdPath(from: view.center, to: nextPoint.center)
            next.path = line
            view.nextPath?.toPoint?.prevPath?.path = line
        }
    }
    
    func removePaths(view: ShapeView) {
        if let prevPoint = view.prevPath?.toPoint, let nextPoint = view.nextPath?.toPoint {
            let line = createdPath(from: prevPoint.center, to: nextPoint.center)
            view.prevPath?.toPoint?.nextPath = Path(toPoint: nextPoint, path: line)
            view.nextPath?.toPoint?.prevPath = Path(toPoint: prevPoint, path: line)
        }
        
        if let prev = view.prevPath {
            prev.path?.removeFromSuperlayer()
            if view.nextPath == nil {
                view.prevPath?.toPoint?.nextPath = nil
            }
        }
        
        if let next = view.nextPath {
            next.path?.removeFromSuperlayer()
            if view.prevPath == nil {
                view.nextPath?.toPoint?.prevPath = nil
            }
        }
        
        view.nextPath = nil
        view.prevPath = nil
    }
    
    func bezie(points: [CGPoint]) {
        var finalPoints = [CGPoint]()
        var t: CGFloat = 0
        while t < 1 {
            finalPoints.append(calculateBezieFunction(t: t, points: points))
            t += 0.002
        }
        drawCurve(points: finalPoints)
    }
    
    func calculateBezieFunction(t: CGFloat, points: [CGPoint]) -> CGPoint {
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        let n = points.count - 1
        for i in 0...n {
            x += CGFloat(fact(number: n)/(fact(number: i) * fact(number: n - i))) * points[i].x * pow(t, CGFloat(i)) * pow(1 - t, CGFloat(n - i))
            y += CGFloat(fact(number: n)/(fact(number: i) * fact(number: n - i))) * points[i].y * pow(t, CGFloat(i)) * pow(1 - t, CGFloat(n - i))
        }
        return CGPoint(x: x, y: y)
    }
    
    func fact(number: Int) -> Int {
        if (number <= 1) {
            return 1
        }
        return number * fact(number: number - 1)
    }
    
    func clearPath() {
        for pointView in beziePath {
            pointView.removeFromSuperview()
        }
        beziePath.removeAll()
    }
    
    func drawCurve(points: [CGPoint]) {
        for i in 1...points.count - 1 {
            let poitnView = PointView(startPoint: CGPoint(x: points[i - 1].x, y: points[i - 1].y), endPoint: CGPoint(x: points[i].x, y: points[i].y))
            self.contentView?.addSubview(poitnView)
            beziePath.append(poitnView)
        }
    }
}

extension BezierPath: ShapeViewDelegate {
    func shapeView(didRemoveView view: ShapeView) {
        guard let index = shapeViews.index(of: view) else { return }
        let shapeView = shapeViews[index]
        removePaths(view: shapeView)
        shapeViews.remove(at: index)
        view.removeFromSuperview()
        startBezie()
    }
    
    func shapeView(didMove view: ShapeView) {
        updatePaths(view: view)
        startBezie()
    }
}
