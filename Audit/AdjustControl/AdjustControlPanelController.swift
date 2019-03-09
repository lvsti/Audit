//
//  AdjustControlPanelController.swift
//  Cameo
//
//  Created by Tamás Lustyik on 2019. 01. 05..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Cocoa
import HALKit

protocol AdjustControlPanelControllerDelegate: class {
    func adjustControlPanelDidDismiss()
}

final class AdjustControlPanelController: NSWindowController {
    @IBOutlet private weak var nameLabel: NSTextField!
    
    @IBOutlet private weak var booleanBox: NSView!
    @IBOutlet private weak var booleanBoxHiddenConstraint: NSLayoutConstraint!
    @IBOutlet private weak var booleanValueCheckbox: NSButton!
    
    @IBOutlet private weak var selectorBox: NSView!
    @IBOutlet private weak var selectorBoxHiddenConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selectorTableView: NSTableView!

    @IBOutlet private weak var sliderBox: NSView!
    @IBOutlet private weak var sliderBoxHiddenConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sliderValueSlider: NSSlider!
    @IBOutlet private weak var sliderMinValueLabel: NSTextField!
    @IBOutlet private weak var sliderMaxValueLabel: NSTextField!
    @IBOutlet private weak var sliderValueTextField: NSTextField!

    @IBOutlet private weak var levelBox: NSView!
    @IBOutlet private weak var levelBoxHiddenConstraint: NSLayoutConstraint!
    @IBOutlet private weak var levelValueSlider: NSSlider!
    @IBOutlet private weak var levelMinValueLabel: NSTextField!
    @IBOutlet private weak var levelMaxValueLabel: NSTextField!
    @IBOutlet private weak var levelValueTextField: NSTextField!
    @IBOutlet private weak var levelScalarValueTextField: NSTextField!

    @IBOutlet private weak var panBox: NSView!
    @IBOutlet private weak var panBoxHiddenConstraint: NSLayoutConstraint!
    @IBOutlet private weak var panValueSlider: NSSlider!
    @IBOutlet private weak var panValueTextField: NSTextField!
    @IBOutlet private weak var panLeftChannelTextField: NSTextField!
    @IBOutlet private weak var panRightChannelTextField: NSTextField!

    private var controlModel: ControlModel {
        didSet {
            guard isWindowLoaded else { return }
            updateUI()
        }
    }
    
    private let controlID: UInt32
    
    weak var delegate: AdjustControlPanelControllerDelegate?
    
    init?(controlID: UInt32) {
        self.controlID = controlID
        guard let model = Control.model(for: controlID) else {
            return nil
        }
        self.controlModel = model
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        switch controlModel {
        case .boolean(let model):
            booleanBoxHiddenConstraint.priority = .defaultLow
            selectorBoxHiddenConstraint.priority = .defaultHigh
            sliderBoxHiddenConstraint.priority = .defaultHigh
            levelBoxHiddenConstraint.priority = .defaultHigh
            panBoxHiddenConstraint.priority = .defaultHigh
            
            nameLabel.stringValue = model.name
            booleanValueCheckbox.state = model.value ? .on : .off

        case .selector(let model):
            booleanBoxHiddenConstraint.priority = .defaultHigh
            selectorBoxHiddenConstraint.priority = .defaultLow
            sliderBoxHiddenConstraint.priority = .defaultHigh
            levelBoxHiddenConstraint.priority = .defaultHigh
            panBoxHiddenConstraint.priority = .defaultHigh
            
            nameLabel.stringValue = model.name

            selectorTableView.selectRowIndexes(IndexSet(model.currentItemIndices), byExtendingSelection: false)

        case .slider(let model):
            booleanBoxHiddenConstraint.priority = .defaultHigh
            selectorBoxHiddenConstraint.priority = .defaultHigh
            sliderBoxHiddenConstraint.priority = .defaultLow
            levelBoxHiddenConstraint.priority = .defaultHigh
            panBoxHiddenConstraint.priority = .defaultHigh
            
            nameLabel.stringValue = model.name

            sliderValueSlider.minValue = Double(model.rangeMin)
            sliderValueSlider.maxValue = Double(model.rangeMax)
            sliderValueSlider.integerValue = Int(model.value)
            sliderValueTextField.stringValue = "\(model.value)"
            sliderMinValueLabel.stringValue = "\(model.rangeMin)"
            sliderMaxValueLabel.stringValue = "\(model.rangeMax)"
            
        case .level(let model):
            booleanBoxHiddenConstraint.priority = .defaultHigh
            selectorBoxHiddenConstraint.priority = .defaultHigh
            sliderBoxHiddenConstraint.priority = .defaultHigh
            levelBoxHiddenConstraint.priority = .defaultLow
            panBoxHiddenConstraint.priority = .defaultHigh
            
            nameLabel.stringValue = model.name
            
            levelValueSlider.minValue = Double(model.dbRangeMin)
            levelValueSlider.maxValue = Double(model.dbRangeMax)
            levelValueSlider.doubleValue = Double(model.dbValue)
            levelMinValueLabel.stringValue = "\(model.dbRangeMin)"
            levelMaxValueLabel.stringValue = "\(model.dbRangeMax)"
            levelValueTextField.stringValue = "\(model.dbValue)"
            levelScalarValueTextField.stringValue = "(\(String(format: "%.3f", model.scalarValue)))"

        case .stereoPan(let model):
            booleanBoxHiddenConstraint.priority = .defaultHigh
            selectorBoxHiddenConstraint.priority = .defaultHigh
            sliderBoxHiddenConstraint.priority = .defaultHigh
            levelBoxHiddenConstraint.priority = .defaultHigh
            panBoxHiddenConstraint.priority = .defaultLow

            nameLabel.stringValue = model.name

            panValueSlider.minValue = 0
            panValueSlider.maxValue = 1
            panValueSlider.floatValue = model.value
            panValueTextField.stringValue = "\(model.value)"
            panLeftChannelTextField.stringValue = "\(model.panningLeft)"
            panRightChannelTextField.stringValue = "\(model.panningRight)"
        }
    }
    
    override var windowNibName: NSNib.Name? {
        return "AdjustControlPanel"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        updateUI()
    }
    
    @IBAction private func dismissButtonClicked(_ sender: Any?) {
        delegate?.adjustControlPanelDidDismiss()
    }
    
    @IBAction private func booleanValueCheckboxClicked(_ sender: Any?) {
        guard case .boolean(var model) = controlModel else {
            return
        }
        
        model.value = booleanValueCheckbox.state == .on
        
        guard
            BooleanControlProperty.value.setValue(UInt32(model.value ? 1 : 0), in: model.controlID)
        else {
            updateUI()
            return
        }
        
        controlModel = .boolean(model)
    }
    
    @IBAction private func selectorSelectionChanged(_ sender: Any?) {
        guard case .selector(var model) = controlModel else {
            return
        }

        model.currentItemIDs = model.items.enumerated()
            .filter { selectorTableView.selectedRowIndexes.contains($0.offset) }
            .map { $0.element.id }
        
        guard
            SelectorControlProperty.currentItem.setArrayValue(model.currentItemIDs, in: model.controlID)
        else {
            updateUI()
            return
        }
        
        controlModel = .selector(model)
    }
    
    @IBAction private func sliderValueSliderChanged(_ sender: Any?) {
        guard case .slider(var model) = controlModel else {
            return
        }

        model.value = UInt32(sliderValueSlider.intValue)
        
        guard
            SliderControlProperty.value.setValue(model.value, in: model.controlID)
        else {
            updateUI()
            return
        }

        controlModel = .slider(model)
    }

    @IBAction private func sliderValueTextFieldChanged(_ sender: Any?) {
        guard case .slider(var model) = controlModel else {
            return
        }

        model.value = UInt32(sliderValueTextField.intValue)
        
        guard
            SliderControlProperty.value.setValue(model.value, in: model.controlID)
        else {
            updateUI()
            return
        }

        controlModel = .slider(model)
    }

    @IBAction private func levelValueSliderChanged(_ sender: Any?) {
        guard case .level(var model) = controlModel else {
            return
        }
        
        model.dbValue = levelValueSlider.floatValue
        
        guard
            LevelControlProperty.decibelValue.setValue(model.dbValue, in: model.controlID)
        else {
            updateUI()
            return
        }
        
        model.scalarValue = LevelControlProperty.scalarValue.value(in: model.controlID) ?? 0
        
        controlModel = .level(model)
    }
    
    @IBAction private func levelValueTextFieldChanged(_ sender: Any?) {
        guard case .level(var model) = controlModel else {
            return
        }
        
        model.dbValue = levelValueTextField.floatValue
        
        guard
            LevelControlProperty.decibelValue.setValue(model.dbValue, in: model.controlID)
        else {
            updateUI()
            return
        }
        
        model.scalarValue = LevelControlProperty.scalarValue.value(in: model.controlID) ?? 0
        
        controlModel = .level(model)
    }
}

extension AdjustControlPanelController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        guard case .selector(let model) = controlModel else {
            return 0
        }
        
        return model.items.count
    }
}

extension AdjustControlPanelController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard case .selector(let model) = controlModel else {
            return nil
        }
        
        let item = model.items[row]
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "selectorItemCell"),
                                      owner: nil) as! NSTableCellView
        view.textField?.stringValue = "\(item.title) (\(item.kind))"

        return view
    }
}
