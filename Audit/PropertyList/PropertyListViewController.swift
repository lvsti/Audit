//
//  PropertyListViewController.swift
//  Audit
//
//  Created by Tamás Lustyik on 2018. 12. 25..
//  Copyright © 2018. Tamas Lustyik. All rights reserved.
//

import Cocoa
import CoreAudio
import Carbon.HIToolbox
import HALKit

protocol PropertyListViewDelegate: class {
    func propertyListDidJumpToNode(withObjectID objectID: AudioObjectID)
}

final class PropertyListViewController: NSViewController {
    
    @IBOutlet private weak var tableView: NSTableView!
    
    private var translationPanelController: TranslationPanelController!

    private let dataSource = PropertyListDataSource()
    
    weak var delegate: PropertyListViewDelegate?
    
    var currentScope: AudioObjectPropertyScope = AudioObjectProperty.Scope.global {
        didSet {
            if currentScope != oldValue {
                reload()
            }
        }
    }
    
    var currentNode: AudioNode? {
        didSet {
            if currentNode != oldValue {
                reload()
            }
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var nibName: NSNib.Name? {
        return "PropertyListView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }
    
    override func keyDown(with event: NSEvent) {
        guard event.keyCode == kVK_Space, tableView.selectedRow >= 0 else {
            super.keyDown(with: event)
            return
        }

        let rowRect = tableView.rect(ofRow: tableView.selectedRow)
        let cellView = tableView.view(atColumn: 3, row: tableView.selectedRow, makeIfNecessary: false) as! NSTableCellView
        let qlvc = QuickLookViewController()
        qlvc.content = cellView.textField?.stringValue ?? ""
        
        present(qlvc, asPopoverRelativeTo: rowRect, of: tableView, preferredEdge: .maxY, behavior: .transient)
        view.window?.makeFirstResponder(qlvc)
    }
    
    @IBAction private func jumpToObject(_ sender: Any) {
        if let node = currentNode,
           tableView.selectedRow != -1,
           let item = dataSource.itemForRow(tableView.selectedRow),
           let objectID: AudioObjectID = try? item.property.value(in: node.objectID) {
            delegate?.propertyListDidJumpToNode(withObjectID: objectID)
        }
    }
    
    @IBAction private func tableRowDoubleClicked(_ sender: Any) {
        guard
            let node = currentNode,
            let item = dataSource.itemForRow(tableView.selectedRow)
        else {
            return
        }

        showTranslationPanel(for: item.property, in: node.objectID)
    }

    private func showTranslationPanel(for property: Property, in objectID: AudioObjectID) {
        guard translationPanelController == nil else {
            return
        }

        switch property.readSemantics {
        case .translation, .qualifiedRead, .optionallyQualifiedRead: break
        default: return
        }

        translationPanelController = TranslationPanelController(property: property, objectID: objectID)
        translationPanelController.delegate = self
        view.window?.beginSheet(translationPanelController.window!) { _ in
            self.translationPanelController = nil
        }
    }

    func reload() {
        dataSource.reload(forNode: currentNode, scope: currentScope)
        if isViewLoaded {
            tableView.reloadData()
        }
    }
}

extension PropertyListViewController: NSMenuItemValidation {
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.action == #selector(jumpToObject(_:)) {
            guard
                tableView.selectedRow != -1,
                let item = dataSource.itemForRow(tableView.selectedRow),
                item.property.type == .objectID
            else {
                return false
            }
        }
        
        return true
    }
}

extension PropertyListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.sections.count + dataSource.sections.reduce(0) { $0 + $1.items.count }
    }
}

extension PropertyListViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
        return dataSource.indexPathForRow(row)!.item == 0
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return !self.tableView(tableView, isGroupRow: row)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let indexPath = dataSource.indexPathForRow(row) else {
            return nil
        }
        
        if indexPath.item == 0 {
            let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GroupCell"),
                                          owner: nil) as! NSTextField
            view.stringValue = " " + dataSource.sections[indexPath.section].title
            return view
        }
        
        guard let column = tableColumn else {
            return nil
        }
        
        let item = dataSource.itemForRow(row)!
        
        if column.identifier.rawValue == "propertyColumn" {
            let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PropertyCell"),
                                          owner: nil) as! NSTableCellView
            view.textField?.stringValue = item.name
            switch item.property.readSemantics {
            case .read: view.imageView?.image = #imageLiteral(resourceName: "read")
            case .mutatingRead, .translation: view.imageView?.image = #imageLiteral(resourceName: "translation")
            case .qualifiedRead: view.imageView?.image = #imageLiteral(resourceName: "qualified")
            case .optionallyQualifiedRead: view.imageView?.image = #imageLiteral(resourceName: "qualified_opt")
            case .inboundOnly: view.imageView?.image = #imageLiteral(resourceName: "inbound")
            case .inboundOnlyWithStatus: view.imageView?.image = #imageLiteral(resourceName: "inbound_status")
            }
            
            return view
        }
        else if column.identifier.rawValue == "valueColumn" {
            let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"),
                                          owner: nil) as! ValueCellView
            view.textField?.stringValue = item.value
            view.showsLinkButton = item.fourCC != nil
            view.delegate = self
            return view
        }
        else if column.identifier.rawValue == "fourccColumn" {
            let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FourCCCell"),
                                          owner: nil) as! NSTableCellView
            view.textField?.stringValue = "'\(fourCC(from: item.property.selector)!)'"
            return view
        }
        else if column.identifier.rawValue == "settableColumn" {
            let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SettableCell"),
                                          owner: nil) as! NSTableCellView
            let checkbox = view.viewWithTag(1000) as! NSButton
            checkbox.state = item.isSettable ? .on : .off
            
            return view
        }

        return nil
    }
}

extension PropertyListViewController: ValueCellDelegate {
    func valueCellDidClickLinkButton(_ sender: ValueCellView) {
        let clickedRow = tableView.row(for: sender)
        guard
            clickedRow >= 0,
            let item = dataSource.itemForRow(clickedRow),
            let fourCC = item.fourCC
        else {
            return
        }
        
        (NSApp.delegate as? AppDelegate)?.showLookupWindow(for: fourCC)
    }
}

extension PropertyListViewController: TranslationPanelControllerDelegate {
    func translationPanelDidDismiss() {
        view.window?.endSheet(translationPanelController.window!)
    }
}
