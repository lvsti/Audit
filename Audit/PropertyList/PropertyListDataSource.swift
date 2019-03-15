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
    private(set) var items: [PropertyListItem] = []
    
    func reload(forNode node: AudioNode?, scope: AudioObjectPropertyScope) {
        items.removeAll()
        
        guard let node = node else {
            return
        }
        
        struct ObjectID: Property {
            let selector: AudioObjectPropertySelector = kAudioObjectPropertySelectorWildcard
            let type: PropertyType = .objectID
            let readSemantics: PropertyReadSemantics = .read
        }
        
        items.append(PropertyListItem(property: ObjectID(),
                                      name: "objectID",
                                      isSettable: false,
                                      value: "@\(node.objectID)",
                                      fourCC: nil))

        items.append(contentsOf: properties(from: ObjectProperty.self, scope: scope, in: node.objectID))

        if node.classID == AudioClass.system {
            items.append(contentsOf: properties(from: SystemProperty.self, scope: scope, in: node.objectID))
            items.append(contentsOf: properties(from: SystemProperty_Deprecated.self, scope: scope, in: node.objectID))
        }
        else if node.classID.isSubclass(of: AudioClass.transportManager) {
            items.append(contentsOf: properties(from: TransportManagerProperty.self, scope: scope, in: node.objectID))
        }
        else if node.classID.isSubclass(of: AudioClass.box) {
            items.append(contentsOf: properties(from: BoxProperty.self, scope: scope, in: node.objectID))
        }
        else if node.classID.isSubclass(of: AudioClass.device) {
            items.append(contentsOf: properties(from: DeviceProperty.self, scope: scope, in: node.objectID))
            items.append(contentsOf: properties(from: DeviceProperty_Deprecated.self, scope: scope, in: node.objectID))
            
            if node.classID.isSubclass(of: AudioClass.endPointDevice) {
                items.append(contentsOf: properties(from: EndPointDeviceProperty.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.aggregateDevice) {
                items.append(contentsOf: properties(from: AggregateDeviceProperty.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.subDevice) {
                items.append(contentsOf: properties(from: SubDeviceProperty.self, scope: scope, in: node.objectID))
            }
        }
        else if node.classID.isSubclass(of: AudioClass.clockDevice) {
            items.append(contentsOf: properties(from: ClockDeviceProperty.self, scope: scope, in: node.objectID))
        }
        else if node.classID.isSubclass(of: AudioClass.stream) {
            items.append(contentsOf: properties(from: StreamProperty.self, scope: scope, in: node.objectID))
            items.append(contentsOf: properties(from: StreamProperty_Deprecated.self, scope: scope, in: node.objectID))
        }
        else if node.classID.isSubclass(of: AudioClass.control) {
            items.append(contentsOf: properties(from: ControlProperty.self, scope: scope, in: node.objectID))
            items.append(contentsOf: properties(from: ControlProperty_Deprecated.self, scope: scope, in: node.objectID))
            
            if node.classID.isSubclass(of: AudioClass.booleanControl) {
                items.append(contentsOf: properties(from: BooleanControlProperty.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.selectorControl) {
                items.append(contentsOf: properties(from: SelectorControlProperty.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.sliderControl) {
                items.append(contentsOf: properties(from: SliderControlProperty.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.levelControl) {
                items.append(contentsOf: properties(from: LevelControlProperty.self, scope: scope, in: node.objectID))
                items.append(contentsOf: properties(from: LevelControlProperty_Deprecated.self, scope: scope, in: node.objectID))
            }
            else if node.classID.isSubclass(of: AudioClass.stereoPanControl) {
                items.append(contentsOf: properties(from: StereoPanControlProperty.self, scope: scope, in: node.objectID))
            }
        }
        else if node.classID == AudioClass.plugIn {
            items.append(contentsOf: properties(from: PlugInProperty.self, scope: scope, in: node.objectID))
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
