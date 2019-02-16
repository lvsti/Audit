//
//  BrowserWindowController.swift
//  Audit
//
//  Created by Tamás Lustyik on 2019. 02. 16..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Cocoa
import CoreAudio
import AuditLib

final class BrowserWindowController: NSWindowController {
    
    @IBOutlet private weak var splitView: NSSplitView!
    
    @IBOutlet private var toolbar: NSToolbar!
    @IBOutlet private weak var adjustControlToolbarItem: NSToolbarItem!
    @IBOutlet private var scopeSelector: NSSegmentedControl!
    
    private let scopeToolbarItemID = NSToolbarItem.Identifier(rawValue: "scopeItem")
    
    private var currentNode: AudioNode?
    private var currentScope: AudioObjectPropertyScope = AudioObjectProperty.Scope.global
    
    private var splitViewController = NSSplitViewController(nibName: nil, bundle: nil)
    private var objectTreeViewController = ObjectTreeViewController()
    private var propertyListViewController = PropertyListViewController()
    
    init() {
        super.init(window: nil)
        objectTreeViewController.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var windowNibName: NSNib.Name? {
        return "BrowserWindow"
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        window?.toolbar = toolbar
        
        adjustControlToolbarItem.isEnabled = false
        toolbar.insertItem(withItemIdentifier: scopeToolbarItemID, at: 2)
        
        splitViewController.addSplitViewItem(NSSplitViewItem(sidebarWithViewController: objectTreeViewController))
        splitViewController.addSplitViewItem(NSSplitViewItem(viewController: propertyListViewController))
        window?.contentViewController = splitViewController
    }
        
    @IBAction private func adjustControlClicked(_ sender: Any) {
        guard let node = currentNode, node.classID.isSubclass(of: AudioClass.control) else {
            return
        }
        
//        (NSApp.delegate as! AppDelegate).showAdjustControlPanel(for: node.objectID)
    }
    
    @IBAction private func scopeSelectorChanged(_ sender: Any) {
        let scopes: [AudioObjectPropertyScope] = [
            AudioObjectProperty.Scope.global,
            AudioObjectProperty.Scope.deviceInput,
            AudioObjectProperty.Scope.deviceOutput,
            AudioObjectProperty.Scope.devicePlayThrough
        ]
        currentScope = AudioObjectPropertyScope(scopes[scopeSelector.selectedSegment])
        
        propertyListViewController.currentScope = currentScope
    }
    
    @IBAction private func reloadClicked(_ sender: Any) {
        propertyListViewController.reload()
    }
    
}

extension BrowserWindowController: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let previousScopeIndex = scopeSelector.selectedSegment
        
        if let node = currentNode, node.classID.isSubclass(of: AudioClass.device) {
            scopeSelector.segmentCount = 4
            
            ["Global", "Input", "Output", "Play-thru"].enumerated().forEach { tuple in
                scopeSelector.setLabel(tuple.element, forSegment: tuple.offset)
                let width = tuple.element.size(withAttributes: [.font: scopeSelector.font!]).width
                scopeSelector.setWidth(width + 10, forSegment: tuple.offset)
            }
        }
        else {
            scopeSelector.segmentCount = 1
            scopeSelector.setLabel("Global", forSegment: 0)
        }
        
        scopeSelector.sizeToFit()
        scopeSelector.selectedSegment = min(previousScopeIndex, scopeSelector.segmentCount - 1)
        
        let item = NSToolbarItem(itemIdentifier: itemIdentifier)
        item.label = "Scope"
        item.paletteLabel = "Scope"
        item.isEnabled = scopeSelector.segmentCount > 1
        item.view = scopeSelector
        
        return item
    }
}

extension BrowserWindowController: ObjectTreeViewDelegate {
    func objectTreeDidSelectNode(_ node: AudioNode?) {
        currentNode = node
        
        adjustControlToolbarItem.isEnabled = node?.classID.isSubclass(of: AudioClass.control) ?? false

        let index = toolbar.items.firstIndex(where: { $0.itemIdentifier == scopeToolbarItemID })!
        toolbar.removeItem(at: index)
        toolbar.insertItem(withItemIdentifier: scopeToolbarItemID, at: index)

        let scopes: [AudioObjectPropertyScope] = [
            AudioObjectProperty.Scope.global,
            AudioObjectProperty.Scope.deviceInput,
            AudioObjectProperty.Scope.deviceOutput,
            AudioObjectProperty.Scope.devicePlayThrough
        ]
        currentScope = AudioObjectPropertyScope(scopes[scopeSelector.selectedSegment])

        propertyListViewController.currentScope = currentScope
        propertyListViewController.currentNode = currentNode
    }
}
