//
//  ObjectTreeDataSource.swift
//  Cameo
//
//  Created by Tamás Lustyik on 2019. 01. 19..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio
import HALKit

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
                         classID: AudioClass.system,
                         name: "System",
                         children: audioChildren(of: AudioObject.system))
    }
    
    func rowForFirst(where pred: (AudioNode) -> Bool) -> Int? {
        var row = 0
        
        func recursiveFirst(in node: AudioNode, where pred: (AudioNode) -> Bool) -> Bool {
            if pred(node) {
                return true
            }
            
            row += 1
            
            for child in node.children {
                if recursiveFirst(in: child, where: pred) {
                    return true
                }
            }
            
            return false
        }
        
        if recursiveFirst(in: tree, where: pred) {
            return row
        }
        
        return nil
    }
    
    private func audioChildren(of objectID: AudioObjectID) -> [AudioNode] {
        var nodes: [AudioNode] = []
        
        if let children: [AudioObjectID] = try? ObjectProperty.ownedObjects.arrayValue(in: objectID) {
            for child in children {
                let subtree = audioChildren(of: child)
                let name = ObjectProperty.name.description(in: child) ?? "<untitled @\(child)>"
                let classID: AudioClassID = (try? ObjectProperty.class.value(in: child)) ?? AudioClass.object
                nodes.append(AudioNode(objectID: child,
                                       classID: classID,
                                       name: name.isEmpty ? "<untitled @\(child)>" : name,
                                       children: subtree))
            }
        }
        
        return nodes
    }

}
