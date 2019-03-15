//
//  AudioControl.swift
//  Audit
//
//  Created by Tamás Lustyik on 2019. 02. 15..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio
import HALKit

struct SliderControlModel {
    var controlID: AudioObjectID = AudioObjectID(kAudioObjectUnknown)
    var name: String = ""
    var value: UInt32 = 0
    var rangeMin: UInt32 = 0
    var rangeMax: UInt32 = 0
}

struct LevelControlModel {
    var controlID: AudioObjectID = AudioObjectID(kAudioObjectUnknown)
    var name: String = ""
    var scalarValue: Float = 0
    var dbValue: Float = 0
    var dbRangeMin: Float = 0
    var dbRangeMax: Float = 0
    var transferFunction: AudioLevelControlTransferFunction = .tranferFunctionLinear
}

struct BooleanControlModel {
    var controlID: AudioObjectID = AudioObjectID(kAudioObjectUnknown)
    var name: String = ""
    var value: Bool = false
}

struct SelectorControlModel {
    struct Item {
        var id: UInt32
        var title: String
        var kind: UInt32
    }
    var controlID: AudioObjectID = AudioObjectID(kAudioObjectUnknown)
    var name: String = ""
    var items: [Item] = []
    var currentItemIDs: [UInt32] = []
    var currentItemIndices: [Int] {
        return items.enumerated().filter { currentItemIDs.contains($0.element.id) }.map { $0.offset }
    }
}

struct StereoPanControlModel {
    var controlID: AudioObjectID = AudioObjectID(kAudioObjectUnknown)
    var name: String = ""
    var value: Float = 0
    var panningLeft: UInt32 = 0
    var panningRight: UInt32 = 0
}

enum ControlModel {
    case slider(SliderControlModel)
    case level(LevelControlModel)
    case boolean(BooleanControlModel)
    case selector(SelectorControlModel)
    case stereoPan(StereoPanControlModel)
}

enum AudioError: Error {
    case unknown
}

enum Control {
    static func model(for controlID: AudioObjectID) -> ControlModel? {
        let cfName: CFString = (try? ObjectProperty.name.value(in: controlID)) ?? "(untitled)" as CFString

        guard
            let classID: AudioClassID = try? ObjectProperty.class.value(in: controlID)
        else {
            return nil
        }
        
        let name = cfName as String
        
        if classID.isSubclass(of: AudioClass.sliderControl) {
            guard
                let value: UInt32 = try? SliderControlProperty.value.value(in: controlID),
                let range: [UInt32] = try? SliderControlProperty.range.value(in: controlID)
            else {
                return nil
            }
            
            return .slider(SliderControlModel(controlID: controlID,
                                              name: name,
                                              value: value,
                                              rangeMin: range[0],
                                              rangeMax: range[1]))
        }
        else if classID.isSubclass(of: AudioClass.levelControl) {
            guard
                let scalarValue: Float = try? LevelControlProperty.scalarValue.value(in: controlID),
                let dbValue: Float = try? LevelControlProperty.decibelValue.value(in: controlID),
                let dbRange: AudioValueRange = try? LevelControlProperty.decibelRange.value(in: controlID),
                let transferFunction: UInt32 = try? LevelControlProperty_Deprecated.decibelsToScalarTransferFunction.value(in: controlID)
            else {
                return nil
            }
            
            return .level(LevelControlModel(controlID: controlID,
                                            name: name,
                                            scalarValue: scalarValue,
                                            dbValue: dbValue,
                                            dbRangeMin: Float(dbRange.mMinimum),
                                            dbRangeMax: Float(dbRange.mMaximum),
                                            transferFunction: AudioLevelControlTransferFunction(rawValue: transferFunction)!))
        }
        else if classID.isSubclass(of: AudioClass.booleanControl) {
            guard
                let value: UInt32 = try? BooleanControlProperty.value.value(in: controlID)
            else {
                return nil
            }
            
            return .boolean(BooleanControlModel(controlID: controlID, name: name, value: value != 0))
        }
        else if classID.isSubclass(of: AudioClass.selectorControl) {
            guard
                let itemIDs: [UInt32] = try? SelectorControlProperty.availableItems.arrayValue(in: controlID),
                let items: [SelectorControlModel.Item] = try? itemIDs.map({
                    guard
                        let cfItemName: CFString = try? SelectorControlProperty.itemName.value(in: controlID, qualifiedBy: Qualifier(from: $0)),
                        let itemKind: UInt32 = try? SelectorControlProperty.itemKind.value(in: controlID, qualifiedBy: Qualifier(from: $0)) ?? 0
                    else {
                        throw AudioError.unknown
                    }
                    return SelectorControlModel.Item(id: $0, title: cfItemName as String, kind: itemKind)
                }),
                let currentItemIDs: [UInt32] = try? SelectorControlProperty.currentItem.arrayValue(in: controlID)
            else {
                return nil
            }

            return .selector(SelectorControlModel(controlID: controlID,
                                                  name: name,
                                                  items: items,
                                                  currentItemIDs: currentItemIDs))
        }
        else if classID.isSubclass(of: AudioClass.stereoPanControl) {
            guard
                let value: Float = try? StereoPanControlProperty.value.value(in: controlID),
                let panning: [UInt32] = try? StereoPanControlProperty.panningChannels.value(in: controlID)
            else {
                return nil
            }
            
            return .stereoPan(StereoPanControlModel(controlID: controlID,
                                                    name: name,
                                                    value: value,
                                                    panningLeft: panning[0],
                                                    panningRight: panning[1]))
        }
        else {
            return nil
        }
    }
}

