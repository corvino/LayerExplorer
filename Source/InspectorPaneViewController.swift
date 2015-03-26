//
//  InspectorPaneViewController.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/25/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

class InspectorPaneViewController: NSViewController, LayerPropertyFormatterDelegate {

    var layerView : LayerView?
    var dirty : Bool = false

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "layerSelected:", name: "LayerSelected", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "animateChanges:", name: "AnimateChanges", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changesAnimated:", name: "ChangesAnimated", object: nil)
    }

    func markDirty() {
        dirty = true
    }

    func layerSelected(notification: NSNotification) {
        layerView = notification.userInfo!["Layer"] as! LayerView?

        changesAnimated(notification)
    }

    func changesAnimated(notification: NSNotification) {}

    func animateChanges(notification: NSNotification) {}

    func degreesToRadians(degrees: Double) -> Double {
        return degrees * 2 * M_PI / 360
    }
}
