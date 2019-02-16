//
//  ObjectTreeDataSource.swift
//  Cameo
//
//  Created by Tamás Lustyik on 2019. 01. 19..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio
import AuditLib

struct AudioNode: Equatable {
    var objectID: AudioObjectID
    var classID: AudioClassID
    var name: String
    var children: [AudioNode]
}

final class ObjectTreeDataSource {
    
    private(set) var tree = AudioNode(objectID: AudioObject.system,
                                      classID: AudioClass.object,
                                      name: "System",
                                      children: [])
    
    func reload() {
        tree = AudioNode(objectID: AudioObject.system,
                         classID: AudioClass.object,
                         name: "System",
                         children: AudioChildren(of: AudioObject.system))
    }
    
    private func AudioChildren(of objectID: AudioObjectID) -> [AudioNode] {
        var nodes: [AudioNode] = []
        
        if let children: [AudioObjectID] = ObjectProperty.ownedObjects.arrayValue(in: objectID) {
            for child in children {
                let subtree = AudioChildren(of: child)
                let name = ObjectProperty.name.description(in: child) ?? "<untitled @\(child)>"
                let classID: AudioClassID = ObjectProperty.class.value(in: child) ?? AudioClass.object
                nodes.append(AudioNode(objectID: child,
                                       classID: classID,
                                       name: name.isEmpty ? "<untitled @\(child)>" : name,
                                       children: subtree))
            }
        }
        
        return nodes
    }

}
