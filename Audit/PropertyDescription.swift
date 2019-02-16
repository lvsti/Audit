//
//  PropertyDescription.swift
//  Cameo
//
//  Created by Tamás Lustyik on 2019. 01. 19..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio
import AuditLib

func fourCC(from value: UInt32) -> String? {
    let chars: [UInt8] = [
        UInt8((value >> 24) & 0xff),
        UInt8((value >> 16) & 0xff),
        UInt8((value >> 8) & 0xff),
        UInt8(value & 0xff)
    ]
    return String(bytes: chars, encoding: .ascii)
}

func fourCCDescription(from value: UInt32) -> String? {
    guard let fcc = fourCC(from: value) else {
        return nil
    }
    
    if let entry = FourCCDatabase.shared.entry(forValue: Int(value)) {
        return "'\(fcc)' (\(entry.constantName))"
    }
    
    return "'\(fcc)'"
}


extension Property {
    func description(scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                     element: AudioObjectPropertyElement = AudioObjectProperty.Element.any,
                     qualifiedBy qualifier: QualifierProtocol? = nil,
                     in objectID: AudioObjectID) -> String? {

        func getValue<T>() -> T? {
            return value(scope: scope, element: element, qualifiedBy: qualifier, in: objectID)
        }

        func getArrayValue<T>() -> [T]? {
            return arrayValue(scope: scope, element: element, qualifiedBy: qualifier, in: objectID)
        }

        switch type {
        case .boolean32:
            if let value: UInt32 = getValue() {
                return value != 0 ? "true (\(value))" : "false (0)"
            }
        case .uint32:
            if let value: UInt32 = getValue() {
                return "\(value)"
            }
        case .float32:
            if let value: Float32 = getValue() {
                return "\(value)"
            }
        case .float64:
            if let value: Float64 = getValue() {
                return "\(value)"
            }
        case .fourCC, .classID:
            if let value: AudioClassID = getValue() {
                if let fcc = fourCCDescription(from: value) {
                    return "\(fcc)"
                }
                return "\(value)"
            }
        case .objectID:
            if let value: AudioObjectID = getValue() {
                return value != kAudioObjectUnknown ? "@\(value)" : "<null>"
            }
        case .audioChannelLayout:
            if let value: AudioChannelLayout = getValue() {
                return "AudioChannelLayout {}"
            }
        case .audioStreamBasicDescription:
            if let value: AudioStreamBasicDescription = getValue() {
                return "AudioStreamBasicDescription {}"
            }
        case .audioValueRange:
            if let value: AudioValueRange = getValue() {
                return "AudioValueRange {\(value.mMinimum), \(value.mMaximum)}"
            }
        case .pid:
            if let value: pid_t = getValue() {
                return "\(value)"
            }
        case .arrayOfUInt32s:
            if let value: [UInt32] = getArrayValue() {
                return "\(value)"
            }
        case .arrayOfObjectIDs, .arrayOfStreamIDs:
            if let value: [AudioObjectID] = getArrayValue() {
                return "[" + value.map { $0 != kAudioObjectUnknown ? "@\($0)" : "<null>" }.joined(separator: ", ") + "]"
            }
        case .arrayOfAudioValueRanges:
            if let value: [AudioValueRange] = getArrayValue() {
                return "[" + value.map { "AudioValueRange {\($0.mMinimum), \($0.mMaximum)}" }.joined(separator: ", ") + "]"
            }
        case .arrayOfAudioStreamRangedDescriptions:
            if let value: [AudioStreamRangedDescription] = getArrayValue() {
                return "[" + value.map { _ in "AudioStreamRangedDescription {}" }.joined(separator: ", ") + "]"
            }
        case .string:
            if let value: CFString = getValue() {
                return "\(value)"
            }
        case .url:
            if let value: CFURL = getValue() {
                return "\(value)"
            }
        case .dictionary:
            if let value: CFDictionary = getValue() {
                return "\(value)"
            }

        default:
            break
        }
        
        return nil
    }
    
    func descriptionForTranslating<T>(_ value: T,
                                      scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                                      element: AudioObjectPropertyElement = AudioObjectProperty.Element.any,
                                      in objectID: AudioObjectID) -> String? {
        guard case .translation(let fromType, let toType) = readSemantics else {
            return nil
        }
        
        func getTranslatedValue<U>() -> U? {
            switch fromType {
            case .float32:
                return translateValue(value, scope: scope, element: element, in: objectID) as? U
            default:
                break
            }
            return nil
        }

        switch toType {
        case .float32:
            if let value: Float = getTranslatedValue() {
                return "\(value)"
            }
        default:
            break
        }

        return nil
    }
}
