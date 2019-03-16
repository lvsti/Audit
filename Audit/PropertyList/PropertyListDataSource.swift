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

class PropertyListDataSource {
    private(set) var sections: [(String, [PropertyListItem])] = []
    var items: [PropertyListItem] {
        return sections.flatMap { $0.1 }
    }
    
    func indexPathForRow(_ row: Int) -> IndexPath? {
        var offset = 0
        var section = 0
        while row > offset {
            if row <= offset + sections[section].1.count {
                break
            }
            offset += sections[section].1.count + 1
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
        
        return indexPath.item == 0 ? nil : sections[indexPath.section].1[indexPath.item - 1]
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
        
        let selfItem = PropertyListItem(property: ObjectID(),
                                        name: "objectID",
                                        isSettable: false,
                                        value: "@\(node.objectID)",
                                        fourCC: nil)

        sections.append(("Object", [selfItem] + properties(from: ObjectProperty.self, scope: scope, in: node.objectID)))

        if node.classID == AudioClass.system {
            sections.append(("SystemObject", properties(from: SystemProperty.self, scope: scope, in: node.objectID)))
            sections.append(("SystemObject (deprecated)", properties(from: SystemProperty_Deprecated.self, scope: scope, in: node.objectID)))
        }
        else if node.classID.isSubclass(of: AudioClass.transportManager) {
            sections.append(("TransportManager", properties(from: TransportManagerProperty.self, scope: scope, in: node.objectID)))
        }
        else if node.classID.isSubclass(of: AudioClass.box) {
            sections.append(("Box", properties(from: BoxProperty.self, scope: scope, in: node.objectID)))
        }
        else if node.classID.isSubclass(of: AudioClass.device) {
            sections.append(("Device", properties(from: DeviceProperty.self, scope: scope, in: node.objectID)))
            sections.append(("Device (deprecated)", properties(from: DeviceProperty_Deprecated.self, scope: scope, in: node.objectID)))
            
            if node.classID.isSubclass(of: AudioClass.endPointDevice) {
                sections.append(("EndPointDevice", properties(from: EndPointDeviceProperty.self, scope: scope, in: node.objectID)))
            }
            else if node.classID.isSubclass(of: AudioClass.aggregateDevice) {
                sections.append(("AggregateDevice", properties(from: AggregateDeviceProperty.self, scope: scope, in: node.objectID)))
            }
            else if node.classID.isSubclass(of: AudioClass.subDevice) {
                sections.append(("SubDevice", properties(from: SubDeviceProperty.self, scope: scope, in: node.objectID)))
            }
        }
        else if node.classID.isSubclass(of: AudioClass.clockDevice) {
            sections.append(("ClockDevice", properties(from: ClockDeviceProperty.self, scope: scope, in: node.objectID)))
        }
        else if node.classID.isSubclass(of: AudioClass.stream) {
            sections.append(("Stream", properties(from: StreamProperty.self, scope: scope, in: node.objectID)))
            sections.append(("Stream (deprecated)", properties(from: StreamProperty_Deprecated.self, scope: scope, in: node.objectID)))
        }
        else if node.classID.isSubclass(of: AudioClass.control) {
            sections.append(("Control", properties(from: ControlProperty.self, scope: scope, in: node.objectID)))
            sections.append(("Control (deprecated)", properties(from: ControlProperty_Deprecated.self, scope: scope, in: node.objectID)))
            
            if node.classID.isSubclass(of: AudioClass.booleanControl) {
                sections.append(("BooleanControl", properties(from: BooleanControlProperty.self, scope: scope, in: node.objectID)))
            }
            else if node.classID.isSubclass(of: AudioClass.selectorControl) {
                sections.append(("SelectorControl", properties(from: SelectorControlProperty.self, scope: scope, in: node.objectID)))
            }
            else if node.classID.isSubclass(of: AudioClass.sliderControl) {
                sections.append(("SliderControl", properties(from: SliderControlProperty.self, scope: scope, in: node.objectID)))
            }
            else if node.classID.isSubclass(of: AudioClass.levelControl) {
                sections.append(("LevelControl", properties(from: LevelControlProperty.self, scope: scope, in: node.objectID)))
                sections.append(("LevelControl (deprecated)", properties(from: LevelControlProperty_Deprecated.self, scope: scope, in: node.objectID)))
            }
            else if node.classID.isSubclass(of: AudioClass.stereoPanControl) {
                sections.append(("StereoPanControl", properties(from: StereoPanControlProperty.self, scope: scope, in: node.objectID)))
            }
        }
        else if node.classID == AudioClass.plugIn {
            sections.append(("PlugIn", properties(from: PlugInProperty.self, scope: scope, in: node.objectID)))
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
