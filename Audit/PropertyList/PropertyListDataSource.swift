//
//  PropertyListDataSource.swift
//  Cameo
//
//  Created by Tamás Lustyik on 2019. 01. 19..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio
import HALKit

struct PropertyListItem {
    var property: Property
    var name: String
    var isSettable: Bool
    var value: String
    var fourCC: UInt32?
}

struct PropertyListSection {
    var title: String
    var items: [PropertyListItem]
}

class PropertyListDataSource {
    private(set) var sections: [PropertyListSection] = []
    var items: [PropertyListItem] {
        return sections.flatMap { $0.items }
    }
    
    func indexPathForRow(_ row: Int) -> IndexPath? {
        var offset = 0
        var section = 0
        while row > offset {
            if row <= offset + sections[section].items.count {
                break
            }
            offset += sections[section].items.count + 1
            section += 1
            
            if section >= sections.count {
                return nil
            }
        }
        return IndexPath(item: row - offset, section: section)
    }
    
    func itemForRow(_ row: Int) -> PropertyListItem? {
        guard let indexPath = indexPathForRow(row) else {
            return nil
        }
        
        return indexPath.item == 0 ? nil : sections[indexPath.section].items[indexPath.item - 1]
    }
    
    func reload(forNode node: AudioNode?, scope: AudioObjectPropertyScope) {
        sections.removeAll()
        
        guard let node = node else {
            return
        }
        
        struct ObjectID: Property {
            let selector: AudioObjectPropertySelector = kAudioObjectPropertySelectorWildcard
            let type: PropertyType = .objectID
            let readSemantics: PropertyReadSemantics = .read
        }
        
        func addSection(_ title: String, items: [PropertyListItem]) {
            guard !items.isEmpty else { return }
            sections.append(PropertyListSection(title: title, items: items))
        }

        let selfItem = PropertyListItem(property: ObjectID(),
                                        name: "objectID",
                                        isSettable: false,
                                        value: "@\(node.objectID)",
                                        fourCC: nil)

        addSection("Object", items: [selfItem] + properties(from: ObjectProperty.self, scope: scope, in: node.objectID))

        if node.classID == AudioClass.system {
            addSection("SystemObject", items: properties(from: SystemProperty.self, scope: scope, in: node.objectID))
            addSection("SystemObject (deprecated)", items: properties(from: SystemProperty_Deprecated.self, scope: scope, in: node.objectID))
        }
        else if node.classID.isSubclass(of: AudioClass.transportManager) {
            addSection("TransportManager", items: properties(from: TransportManagerProperty.self, scope: scope, in: node.objectID))
        }
        else if node.classID.isSubclass(of: AudioClass.box) {
            addSection("Box", items: properties(from: BoxProperty.self, scope: scope, in: node.objectID))
        }
        else if node.classID.isSubclass(of: AudioClass.device) {
            addSection("Device", items: properties(from: DeviceProperty.self, scope: scope, in: node.objectID))
            addSection("Device (deprecated)", items: properties(from: DeviceProperty_Deprecated.self, scope: scope, in: node.objectID))
            
            if node.classID.isSubclass(of: AudioClass.endPointDevice) {
                addSection("EndPointDevice", items: properties(from: EndPointDeviceProperty.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.aggregateDevice) {
                addSection("AggregateDevice", items: properties(from: AggregateDeviceProperty.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.subDevice) {
                addSection("SubDevice", items: properties(from: SubDeviceProperty.self, scope: scope, in: node.objectID))
            }
        }
        else if node.classID.isSubclass(of: AudioClass.clockDevice) {
            addSection("ClockDevice", items: properties(from: ClockDeviceProperty.self, scope: scope, in: node.objectID))
        }
        else if node.classID.isSubclass(of: AudioClass.stream) {
            addSection("Stream", items: properties(from: StreamProperty.self, scope: scope, in: node.objectID))
            addSection("Stream (deprecated)", items: properties(from: StreamProperty_Deprecated.self, scope: scope, in: node.objectID))
        }
        else if node.classID.isSubclass(of: AudioClass.control) {
            addSection("Control", items: properties(from: ControlProperty.self, scope: scope, in: node.objectID))
            addSection("Control (deprecated)", items: properties(from: ControlProperty_Deprecated.self, scope: scope, in: node.objectID))
            
            if node.classID.isSubclass(of: AudioClass.booleanControl) {
                addSection("BooleanControl", items: properties(from: BooleanControlProperty.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.selectorControl) {
                addSection("SelectorControl", items: properties(from: SelectorControlProperty.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.sliderControl) {
                addSection("SliderControl", items: properties(from: SliderControlProperty.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.levelControl) {
                addSection("LevelControl", items: properties(from: LevelControlProperty.self, scope: scope, in: node.objectID))
                addSection("LevelControl (deprecated)", items: properties(from: LevelControlProperty_Deprecated.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.stereoPanControl) {
                addSection("StereoPanControl", items: properties(from: StereoPanControlProperty.self, scope: scope, in: node.objectID))
            }
        }
        else if node.classID == AudioClass.plugIn {
            addSection("PlugIn", items: properties(from: PlugInProperty.self, scope: scope, in: node.objectID))
        }
    }
    
    private func properties<S>(from type: S.Type,
                               scope: AudioObjectPropertyScope,
                               in objectID: AudioObjectID) -> [PropertyListItem] where S: PropertySet {
        var propertyList: [PropertyListItem] = []
        let props = S.allExisting(scope: scope,
                                  element: AudioObjectProperty.Element.any,
                                  in: objectID)
        for prop in props {
            let isFourCC = prop.type == .fourCC || prop.type == .classID
            let desc = prop.description(scope: scope, in: objectID)
            let item = PropertyListItem(property: prop,
                                        name: "\(prop)",
                                        isSettable: prop.isSettable(in: objectID, scope: scope),
                                        value: desc ?? "#ERROR",
                                        fourCC: isFourCC && desc != nil ? try? prop.value(in: objectID, scope: scope) : nil)
            propertyList.append(item)
        }
        return propertyList
    }
    
}
