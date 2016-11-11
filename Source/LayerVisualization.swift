//
//  LayerView.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 3/17/15.
//  Copyright (c) 2015 Nathan Corvino. All rights reserved.
//

import Cocoa

// This is the interface needed by the inspectors to read and update the visualization properties.
protocol LayerVisualization {
    var frame: CGRect { get set }
    var bounds: CGRect { get set }
    var position: CGPoint { get set }
    var anchorPoint: CGPoint { get set }
    var anchorPointZ: CGFloat { get set }
    var affineTransform: CGAffineTransform { get set }
    var transform: CATransform3D { get set }
}

// This is the concrete realization of the LayerVisualization protocol.
// It binds together the layers involved in creating the visualization and updates
// the visualization when properties change.
class Visualization : LayerVisualization {
    fileprivate let frameShape: CALayer
    fileprivate let anchorDot: CAShapeLayer
    fileprivate let modelLayer: CALayer

    required init(frameShape: CALayer, anchorDot: CAShapeLayer, modelLayer: CALayer) {
        self.frameShape = frameShape
        self.anchorDot = anchorDot
        self.modelLayer = modelLayer
    }

    var frame : CGRect {
        get { return modelLayer.frame }
        set(newFrame) {
            modelLayer.frame = newFrame
            updateVisualizations()
        }
    }

    var bounds: CGRect {
        get { return modelLayer.bounds }
        set(newFrame) {
            modelLayer.bounds = newFrame
            updateVisualizations()
        }
    }

    var position : CGPoint {
        get { return modelLayer.position }
        set(newPosition) {
            modelLayer.position = newPosition
            updateVisualizations()
        }
    }

    var anchorPoint : CGPoint {
        get { return modelLayer.anchorPoint }
        set(newAnchorPoint) {
            modelLayer.anchorPoint = newAnchorPoint
            updateVisualizations()
        }
    }

    var anchorPointZ : CGFloat {
        get { return modelLayer.anchorPointZ }
        set(newAnchorPointZ) {
            modelLayer.anchorPointZ = newAnchorPointZ
            updateVisualizations()
        }
    }

    var affineTransform : CGAffineTransform {
        get { return modelLayer.affineTransform() }
        set(newAffineTransform) {
            modelLayer.setAffineTransform(newAffineTransform)
            updateVisualizations()
        }
    }

    var transform : CATransform3D {
        get { return modelLayer.transform }
        set(newTransform) {
            modelLayer.transform = newTransform
            updateVisualizations()
        }
    }

    func updateVisualizations() {
        frameShape.frame = modelLayer.frame
        if let _ = modelLayer.superlayer {
            var newPosition = CGPoint(x: anchorPoint.x * bounds.width + bounds.origin.x, y: anchorPoint.y * bounds.height + bounds.origin.y)
            newPosition = (modelLayer.superlayer?.convert(newPosition, from: modelLayer))!
            anchorDot.position = newPosition
        }
    }
}
