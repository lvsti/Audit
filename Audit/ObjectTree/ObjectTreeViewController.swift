//
//  ObjectTreeViewController.swift
//  Audit
//
//  Created by Tamás Lustyik on 2019. 02. 16..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Cocoa
import CoreAudio
import AuditLib

protocol ObjectTreeViewDelegate: class {
    func objectTreeDidSelectNode(_ node: AudioNode?)
}

final class ObjectTreeViewController: NSViewController {
    
    @IBOutlet private weak var treeView: NSOutlineView!

    private let dataSource = ObjectTreeDataSource()
    
    weak var delegate: ObjectTreeViewDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var nibName: NSNib.Name? {
        return "ObjectTreeView"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.reload()
        
        treeView.reloadData()
        treeView.expandItem(nil, expandChildren: true)
    }

}

extension ObjectTreeViewController: NSOutlineViewDelegate {
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard treeView.selectedRow >= 0 else {
            return
        }
        
        let node = treeView.item(atRow: treeView.selectedRow) as! AudioNode
        delegate?.objectTreeDidSelectNode(node)
    }
}

extension ObjectTreeViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let item = item else {
            return 1
        }
        
        return (item as! AudioNode).children.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let item = item else {
            return dataSource.tree
        }
        
        return (item as! AudioNode).children[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return !(item as! AudioNode).children.isEmpty
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        return "foobar"
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"),
                                        owner: nil) as! NSTableCellView
        let node = item as! AudioNode
        view.textField?.stringValue = node.name
        
        var image: NSImage?
        switch node.classID {
        case _ where node.classID.isSubclass(of: AudioClass.plugIn):
            image = NSImage(named: NSImage.shareTemplateName)
        case _ where node.classID.isSubclass(of: AudioClass.device):
            image = NSImage(named: NSImage.computerName)
        case AudioClass.clockDevice:
            image = NSImage(named: NSImage.touchBarAlarmTemplateName)
        case AudioClass.stream:
            image = NSImage(named: NSImage.slideshowTemplateName)
        case _ where node.classID.isSubclass(of: AudioClass.control):
            image = NSImage(named: NSImage.preferencesGeneralName)
        case _ where node.name == "System":
            image = NSImage(named: NSImage.networkName)
        default:
            image = NSImage(named: NSImage.touchBarIconViewTemplateName)
        }
        
        view.imageView?.image = image
        
        return view
    }
}

