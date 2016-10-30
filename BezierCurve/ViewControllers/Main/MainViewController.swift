//
//  MainViewController.swift
//  BezierCurve
//
//  Created by Семен Никулин on 20.10.16.
//  Copyright © 2016 niksemv. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var beziePath: BezierPath = {
        return BezierPath(view: self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTapGestureRecognizer()
    }
    
    func initTapGestureRecognizer() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap))
        tapGR.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGR)
    }
    
    func didTap(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        beziePath.appendView(point: point)
        beziePath.startBezie()
    }
}
