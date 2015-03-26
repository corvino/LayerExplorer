//
//  CanvasViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/17/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class CanvasViewController: NSViewController {

    var layerView : LayerView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor

        let centerFramePoint = CGPoint(x: (self.view.bounds.size.width - 100) / 2, y: (self.view.bounds.size.height - 100) / 2)
        layerView = LayerView()
        layerView!.frame = CGRect(origin: centerFramePoint, size: CGSize(width: 100, height: 100))
        layerView!.addToLayer(self.view.layer!)
    }

    override func viewDidAppear() {
        if let layer = layerView {
            // Is there really not a better way to do this in Swift?
            // Do we have to wait for class stored properties to stop being an animal?
            NSNotificationCenter.defaultCenter().postNotificationName("LayerSelected", object: nil, userInfo: ["Layer" : layer])
        }
    }
}
