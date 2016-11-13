//
//  InfiniteClipView.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 11/12/16.
//  Copyright © 2016 Nathan Corvino. All rights reserved.
//

// Thanks to Milen Dzhumerov's post https://blog.helftone.com/infinite-nsscrollview/ and
// sample code https://github.com/helftone/infinite-nsscrollview from which this was adapted.
// He has nice diagrams done in Monodraw.

import Cocoa

extension Notification.Name {
    static let infiniteClipViewWarped = Notification.Name("infite-clip-view-warped")
}

class InfiniteClipView: NSClipView {
    private static let recenterThreshold: CGFloat = 500

    var totalOffset = CGPoint.zero

    private var needsRecenter = false

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(onGeometryChange), name: .NSViewBoundsDidChange, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(onGeometryChange), name: .NSViewFrameDidChange, object: self)
    }

    func onGeometryChange() {
        if nil != recenterOffset {
            setNeedsRecenter()
        }
    }

    private func setNeedsRecenter() {
        if !needsRecenter {
            needsRecenter = true
            DispatchQueue.main.async {
                self.recenter()
                self.needsRecenter = false
            }
        }
    }

    private func recenter() {
        guard let offset = recenterOffset else { return }
        guard let documentView = documentView else { return }

        let documentOrigin = documentView.bounds.origin

        totalOffset = CGPoint(x: totalOffset.x + offset.x, y: totalOffset.y + offset.y)

        // Recenter the clip view. Make an inverse adjustment to the document view to keep its view port the same.
        documentView.setBoundsOrigin(CGPoint(x: documentOrigin.x - offset.x, y: documentOrigin.y - offset.y))
        setBoundsOrigin(CGPoint(x: bounds.origin.x + offset.x, y: bounds.origin.y + offset.y))

        NotificationCenter.default.post(Notification(name: .infiniteClipViewWarped, object: self, userInfo: nil))
    }

    private var recenterOffset: CGPoint? {
        get {
            guard let docFrame = documentView?.frame else { return nil }
            let clipBounds = bounds

            let leftMargin = clipBounds.minX - docFrame.minX
            let rightMargin = docFrame.maxX - clipBounds.maxX
            let topMargin = docFrame.maxY - clipBounds.maxY
            let bottomMargin = clipBounds.minY - docFrame.minY

            if min(leftMargin, rightMargin, topMargin, bottomMargin) < InfiniteClipView.recenterThreshold {
                let recenterClipOrigin = CGPoint(x: docFrame.minX + round((docFrame.size.width - clipBounds.size.width) / 2),
                                                 y: docFrame.minY + round((docFrame.size.height - clipBounds.size.height) / 2))
                return CGPoint(x: recenterClipOrigin.x - clipBounds.origin.x, y: recenterClipOrigin.y - clipBounds.origin.y)
            }

            return nil
        }
    }

    override func scroll(_ point: NSPoint) {
        // Disable smooth scrolling
        setBoundsOrigin(point)
    }
}
