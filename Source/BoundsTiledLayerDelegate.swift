//
//  BoundsTiledLayerDelegate.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 11/11/16.
//  Copyright © 2016 Nathan Corvino. All rights reserved.
//

import Cocoa

// This draws the hashes to visualize bounds into the tiled layer.
class BoundsTiledLayerDelegate : NSObject, CALayerDelegate {
    let hashColors = [NSColor.green, NSColor.black, NSColor.yellow, NSColor.orange, NSColor.cyan, NSColor.magenta, NSColor.purple, NSColor.brown]
    let hashSpacing = 100
    let hashFactor = 100
    let hashRadius : CGFloat = 8.0
    let hashWidth : CGFloat = 2.0
    let fontSize : CGFloat = 17.0

    func colorForHash(_ hash : CGPoint) -> NSColor {
        return hashColors[((Int(hash.x) + 2 * Int(hash.y)) / hashSpacing) % hashColors.count]
    }

    func draw(_ layer: CALayer, in context: CGContext) {
        let box = context.boundingBoxOfClipPath
        guard box.origin.x != CGFloat.infinity && box.origin.y != CGFloat.infinity else { return }

        let startX = (Int(box.origin.x) / hashSpacing) * hashSpacing
        let startY = (Int(box.origin.y) / hashSpacing) * hashSpacing

        // We know this font is there, so "cheat" and use crash operator.
        let font = NSFont(name: "Helvetica", size: fontSize)!

        context.textMatrix = CGAffineTransform(scaleX: 1, y: 1)
        context.setLineWidth(hashWidth)

        var x = startX
        while CGFloat(x) < box.origin.x + box.size.width {
            var y = startY
            while CGFloat(y) < box.origin.y + box.size.height {
                let hash = CGPoint(x: x, y: y)
                let color = colorForHash(hash)
                let points = [ CGPoint(x: hash.x - hashRadius, y: hash.y), CGPoint(x: hash.x + hashRadius, y: hash.y),
                               CGPoint(x: hash.x, y: hash.y - hashRadius), CGPoint(x: hash.x, y: hash.y + hashRadius)]
                context.setStrokeColor(color.cgColor)
                context.setFillColor(color.cgColor)
                context.strokeLineSegments(between: points)

                let textAttributes = [ NSFontAttributeName : font, NSForegroundColorAttributeName : color ]

                let xDisplay = (x + Int(layer.frame.origin.x)) /  hashFactor
                let yDisplay = (y + Int(layer.frame.origin.y)) / hashFactor
                let xyText = NSAttributedString(string: "(\(xDisplay),\(yDisplay))", attributes: textAttributes)

                context.saveGState()
                context.textPosition = CGPoint(x: hash.x + 7, y: hash.y + 7)
                CTLineDraw(CTLineCreateWithAttributedString(xyText), context)
                context.restoreGState()
                y += hashSpacing
            }
            x += hashSpacing
        }
    }
}
