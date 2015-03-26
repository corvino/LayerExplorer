//
//  CanvasViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/17/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class CanvasViewController: NSViewController {

    var layerVisualization : LayerVisualization?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer?.backgroundColor = NSColor.lightGrayColor().CGColor

        let size = CGSize(width: 250, height: 250)
        let centerFramePoint = CGPoint(x: (self.view.bounds.size.width - size.width) / 2, y: (self.view.bounds.size.height - size.height) / 2)
        layerVisualization = LayerVisualization()
        layerVisualization!.frame = CGRect(origin: centerFramePoint, size: size)
        layerVisualization!.addToLayer(self.view.layer!)
    }

    override func viewDidAppear() {
        if nil != layerVisualization {
            // Is there really not a better way to do this in Swift?
            // Do we have to wait for class stored properties to stop being an animal?
            NSNotificationCenter.defaultCenter().postNotificationName("LayerSelected", object: nil, userInfo: ["Layer" : layerVisualization!])
        }
    }
}
