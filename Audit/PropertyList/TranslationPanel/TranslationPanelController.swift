//
//  TranslationPanelController.swift
//  Cameo
//
//  Created by Tamás Lustyik on 2019. 02. 01..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Cocoa
import AuditLib

protocol TranslationPanelControllerDelegate: class {
    func translationPanelDidDismiss()
}

final class TranslationPanelController: NSWindowController {
    @IBOutlet private weak var sourceField: NSTextField!
    @IBOutlet private weak var valueLabel: NSTextField!
    @IBOutlet private weak var sourceLabel: NSTextField!
    @IBOutlet private weak var actionButton: NSButton!

    weak var delegate: TranslationPanelControllerDelegate?
    
    private let translation: (String) -> String
    private let property: Property

    init?(property: Property, objectID: UInt32) {
        self.property = property
        self.translation = {
            property.descriptionForReading(withInput: $0, in: objectID) ?? "#ERROR"
        }
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var windowNibName: NSNib.Name? {
        return "TranslationPanel"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if case .translation = property.readSemantics {
            sourceLabel.stringValue = "Translate from:"
            actionButton.title = "Translate"
        }
        else {
            sourceLabel.stringValue = "Qualifier:"
            actionButton.title = "Query"
        }
        valueLabel.stringValue = ""
    }

    @IBAction private func translateButtonClicked(_ sender: Any?) {
        valueLabel.stringValue = translation(sourceField.stringValue)
    }
    
    @IBAction private func dismissButtonClicked(_ sender: Any?) {
        delegate?.translationPanelDidDismiss()
    }
}
