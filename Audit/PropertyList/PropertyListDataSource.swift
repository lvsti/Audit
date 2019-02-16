//
//  PropertyListDataSource.swift
//  Cameo
//
//  Created by Tamás Lustyik on 2019. 01. 19..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio
import AuditLib

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

        if node.classID.isSubclass(of: AudioClass.device) {
            items.append(contentsOf: properties(from: DeviceProperty.self, scope: scope, in: node.objectID))
            
            if node.classID.isSubclass(of: AudioClass.endPointDevice) {
                items.append(contentsOf: properties(from: EndPointDeviceProperty.self, scope: scope, in: node.objectID))
            }
        }
        else if node.classID.isSubclass(of: AudioClass.stream) {
            items.append(contentsOf: properties(from: StreamProperty.self, scope: scope, in: node.objectID))
        }
        else if node.classID.isSubclass(of: AudioClass.control) {
            items.append(contentsOf: properties(from: ControlProperty.self, scope: scope, in: node.objectID))
            
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
                                        isSettable: prop.isSettable(scope: scope, in: objectID),
                                        value: desc ?? "#ERROR",
                                        fourCC: isFourCC && desc != nil ? prop.value(scope: scope, in: objectID) : nil)
            propertyList.append(item)
        }
        return propertyList
    }
    
}
