//
//  CanvasView.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 11/11/16.
//  Copyright © 2016 Nathan Corvino. All rights reserved.
//

import Cocoa

class CanvasView: NSView, CALayerDelegate {

    fileprivate let frameShape = CALayer()
    fileprivate let anchorDot = CAShapeLayer()
    fileprivate let modelLayer = CALayer()
    fileprivate let tiledLayer = CATiledLayer()
    fileprivate let tiledDelegate = BoundsTiledLayerDelegate()

    fileprivate var dragging = false

    public var visualization: LayerVisualization

    required public init?(coder: NSCoder) {
        let layer = CALayer()
        visualization = Visualization(layer: layer, frameShape: frameShape, anchorDot: anchorDot, modelLayer: modelLayer)

        super.init(coder: coder)

        self.layer = layer
        layer.delegate = self
        layer.backgroundColor = NSColor.lightGray.cgColor
        wantsLayer = true

        // It would be nicer to make this layer extend infinitely.
        // But the expedient method for now is to just make it "big enough".
        tiledLayer.frame = CGRect(origin: CGPoint(x: -5000, y:-5000), size: CGSize(width: 10000, height: 10000))
        tiledLayer.delegate = tiledDelegate

        modelLayer.addSublayer(tiledLayer)

        modelLayer.masksToBounds = true
        modelLayer.backgroundColor = NSColor.white.cgColor

        // Putting this "on top" keeps the dot from being clipped when we rotate in 3D.
        // The constant dance is a touch strange; we get a warning if we are larger than FLT_MAX,
        // but it needs to be typed as a CGFloat. Sigh.
        anchorDot.zPosition = CGFloat(Float.greatestFiniteMagnitude)

        anchorDot.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 15, height: 15))
        anchorDot.path = CGPath(ellipseIn: anchorDot.frame, transform: nil)

        frameShape.borderWidth = 3
        frameShape.borderColor = NSColor.blue.cgColor

        layer.addSublayer(modelLayer)
        layer.addSublayer(frameShape)
        layer.addSublayer(anchorDot)

        let panGesture = NSPanGestureRecognizer(target: self, action: #selector(handle(pan:)))
        addGestureRecognizer(panGesture)
    }

    func handle(pan: NSPanGestureRecognizer) {
        switch (pan.state, dragging) {
        case (.began, _):
            let point = pan.location(in: self)
            if modelLayer.frame.contains(point) {
                dragging = true
                pan.setTranslation(visualization.position, in: self)
            }
        case (.changed, true):
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            visualization.position = pan.translation(in: self)
            CATransaction.commit()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ChangesAnimated"), object: pan)
        case (_, true):
            dragging = false
        default:
            break
        }
    }

    override func layer(_ layer: CALayer, shouldInheritContentsScale newScale: CGFloat, from window: NSWindow) -> Bool {
        layer.contentsScale = newScale
        tiledLayer.contentsScale = newScale
        modelLayer.contentsScale = newScale
        frameShape.contentsScale = newScale
        anchorDot.contentsScale = newScale

        return true
    }
}
