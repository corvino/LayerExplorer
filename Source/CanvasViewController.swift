//
//  CanvasViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/17/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class CanvasViewController: NSViewController {

    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var scrollView: NSScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.hasHorizontalRuler = true
        scrollView.hasVerticalRuler = true
        scrollView.horizontalRulerView?.measurementUnits = "Points"
        scrollView.verticalRulerView?.measurementUnits = "Points"
        scrollView.rulersVisible = true

        let size = CGSize(width: 250, height: 250)
        let centerFramePoint = CGPoint(x: (self.view.bounds.size.width - size.width) / 2, y: (self.view.bounds.size.height - size.height) / 2)
        canvasView.visualization.frame = CGRect(origin: centerFramePoint, size: size)
    }

    override func viewDidAppear() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LayerSelected"), object: nil, userInfo: ["Layer" : canvasView.visualization])
    }
}
