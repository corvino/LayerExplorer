//
//  Inspector.swift
//  LayerExplorer
//
//  Created by Nathan Corvino on 12/12/16.
//  Copyright © 2016 Nathan Corvino. All rights reserved.
//

import Cocoa

class Inspector : NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
    @IBOutlet var outlineView: NSOutlineView!

    struct Section {
        let name: String
        let pane: Pane
    }

    struct Pane {
        let controller: NSViewController
    }

    @IBOutlet var frame: NSViewController!

    let sections = [
        Section(name: "Frame", pane: Pane(controller: FrameInspectorViewController(nibName: "Rect", bundle: nil)!)),
        Section(name: "Bounds", pane: Pane(controller: BoundsInspectorViewController(nibName: "Rect", bundle: nil)!)),
        Section(name: "Position", pane: Pane(controller: PositionInspectorViewController(nibName: "Position", bundle: nil)!)),
        Section(name: "Affine Transform", pane: Pane(controller: AffineTransformInspectorViewController(nibName: "Affine", bundle: nil)!)),
        Section(name: "3D Transform", pane: Pane(controller: TransformInspectorViewController(nibName: "3D", bundle: nil)!)),
    ]

    override func awakeFromNib() {
        outlineView.rowSizeStyle = .custom
        outlineView.reloadData()

        NSAnimationContext.beginGrouping()
        NSAnimationContext.current().duration = 0
        outlineView.expandItem(nil, expandChildren: true)
        NSAnimationContext.endGrouping()
    }

    @IBAction func goClicked(_ sender: AnyObject) {
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut))
        CATransaction.setAnimationDuration(0.8)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AnimateChanges"), object: sender)
        CATransaction.commit()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ChangesAnimated"), object: sender)
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if nil == item {
            return sections[index]
        } else if let item = item as? Section {
            return item.pane
        }

        return ""
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return nil == outlineView.parent(forItem: item)
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if nil == item {
            return sections.count
        } else {
            return 1
        }
    }

    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        if let _ = item as? Section {
            return true
        } else {
            return false
        }
    }

    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        if item is Section {
            return 16
        } else if let item = item as? Pane {
            let view = item.controller.view
            view.layoutSubtreeIfNeeded()
            return view.frame.height
        }
        return 0
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let item = item as? Section {
            let header = outlineView.make(withIdentifier: "SectionHeader", owner: self) as? SectionHeaderView
            header?.nameTextField.stringValue = item.name
            return header
        } else if let item = item as? Pane {
            return item.controller.view
        } else {
            return nil
        }
    }

    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        if let row = outlineView.make(withIdentifier: "Row", owner: self) as? NSTableRowView {
            return row
        }

        let row = QuietRowView()
        row.identifier = "Row"
        return row
    }
}

class QuietRowView: NSTableRowView {
    override var isSelected: Bool {
        get { return false }
        set {}
    }
}

class SectionHeaderView: NSView {
    @IBOutlet weak var nameTextField: NSTextField!
}
