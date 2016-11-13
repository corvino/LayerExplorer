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
    @IBOutlet weak var clipView: InfiniteClipView!

    private var hasAppeared = false

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

        NotificationCenter.default.addObserver(self, selector: #selector(infiteClipViewWarped), name: .infiniteClipViewWarped, object: clipView)
    }

    override func viewWillAppear() {
        // viewWillAppear only appears to get called on creation, unlike on iOS when the view may be hidden by
        // modal presentations and navigation controller pushes. However, the flag-dance doesn't hurt anything,
        // so leave it until this is confirmed.
        if !hasAppeared {
            // Set to the origin at start, as it appears to center in the document view.
            clipView.bounds = CGRect(origin: CGPoint.zero, size: clipView.bounds.size)
            hasAppeared = true
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LayerSelected"), object: nil, userInfo: ["Layer" : canvasView.visualization])
    }

    func infiteClipViewWarped() {
        scrollView.horizontalRulerView?.originOffset = clipView.totalOffset.x
        scrollView.verticalRulerView?.originOffset = clipView.totalOffset.y
    }
}
