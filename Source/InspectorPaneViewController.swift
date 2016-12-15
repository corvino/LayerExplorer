//
//  InspectorPaneViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/25/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class InspectorPaneViewController: NSViewController, LayerPropertyFormatterDelegate {

    var layerVisualization : LayerVisualization?
    var dirty : Bool = false

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(InspectorPaneViewController.layerSelected(_:)), name: NSNotification.Name(rawValue: "LayerSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InspectorPaneViewController.animateChanges(_:)), name: NSNotification.Name(rawValue: "AnimateChanges"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InspectorPaneViewController.changesAnimated(_:)), name: NSNotification.Name(rawValue: "ChangesAnimated"), object: nil)
    }

    func wireFormatters(fields: [NSTextField]) {
         // Damn-nabbit; IB should let me set these ... but doesn't.
        for field in fields {
            (field.formatter as! LayerPropertyFormatter).delegate = self
        }
    }

    func markDirty() {
        dirty = true
    }

    func layerSelected(_ notification: Notification) {
        layerVisualization = (notification as NSNotification).userInfo!["Layer"] as! LayerVisualization?

        changesAnimated(notification)
    }

    func changesAnimated(_ notification: Notification) {}

    func animateChanges(_ notification: Notification) {}

    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * 2 * M_PI / 360
    }
}
