//
//  PropertyDescription.swift
//  Cameo
//
//  Created by Tamás Lustyik on 2019. 01. 19..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio
import HALKit

func fourCC(from value: UInt32) -> String? {
    let chars: [UInt8] = [
        UInt8((value >> 24) & 0xff),
        UInt8((value >> 16) & 0xff),
        UInt8((value >> 8) & 0xff),
        UInt8(value & 0xff)
    ]
    guard chars.allSatisfy({ $0 != 0 }) else { return nil }
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
        switch readSemantics {
        case .translation(let fromType, let toType): return "<function: (\(fromType)) -> \(toType)>"
        case .qualifiedRead(let qtype): return "<function: (\(qtype)) -> \(type)>"
        default: break
        }
        
        func getValue<T>() -> T? {
            return try? value(in: objectID, scope: scope, element: element, qualifiedBy: qualifier)
        }

        func getArrayValue<T>() -> [T]? {
            return try? arrayValue(in: objectID, scope: scope, element: element, qualifiedBy: qualifier)
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
            if let value: UInt32 = getValue(), value != 0 {
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
                return "\(value)"
            }
        case .audioStreamBasicDescription:
            if let value: AudioStreamBasicDescription = getValue() {
                return "\(value)"
            }
        case .audioValueRange:
            if let value: AudioValueRange = getValue() {
                return "\(value)"
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
                return "[" + value.map { "\($0)" }.joined(separator: ", ") + "]"
            }
        case .arrayOfAudioStreamRangedDescriptions:
            if let value: [AudioStreamRangedDescription] = getArrayValue() {
                return "[" + value.map { "\($0)" }.joined(separator: ", ") + "]"
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
    
    func descriptionForReading(withInput parameter: String,
                               scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                               element: AudioObjectPropertyElement = AudioObjectProperty.Element.any,
                               in objectID: AudioObjectID) -> String? {
        func getTranslatedValue<U>(from fromType: PropertyType) -> U? {
            switch fromType {
            case .float32:
                return (try? value(in: objectID, scope: scope, element: element, for: Float(parameter))) as! U?
            default:
                break
            }
            return nil
        }
        
        func getQualifiedValue<U>(from fromType: PropertyType) -> U? {
            switch fromType {
            case .string:
                return try? value(in: objectID,
                                  scope: scope,
                                  element: element,
                                  qualifiedBy: Qualifier(from: parameter as CFString))
            case .uint32:
                return try? value(in: objectID,
                                  scope: scope,
                                  element: element,
                                  qualifiedBy: Qualifier(from: UInt32(parameter)))
            default:
                break
            }
            return nil
        }
        
        func getQualifiedArrayValue<U>(from fromType: PropertyType) -> [U]? {
            switch fromType {
            case .arrayOfClassIDs:
                let array = parameter
                    .split(separator: ",")
                    .compactMap { UInt32($0.trimmingCharacters(in: .whitespaces)) }
                return try? arrayValue(in: objectID, scope: scope, element: element, qualifiedBy: Qualifier(fromArray: array))
            default:
                break
            }
            return nil
        }
        
        switch readSemantics {
        case .translation(let fromType, let toType):
            switch toType {
            case .float32:
                if let value: Float = getTranslatedValue(from: fromType) {
                    return "\(value)"
                }
            default:
                break
            }

        case .qualifiedRead(let qtype), .optionallyQualifiedRead(let qtype):
            switch type {
            case .uint32:
                if let value: UInt32 = getQualifiedValue(from: qtype) {
                    return "\(value)"
                }
            case .objectID:
                if let value: AudioObjectID = getQualifiedValue(from: qtype) {
                    return value != kAudioObjectUnknown ? "@\(value)" : "<null>"
                }
            case .arrayOfObjectIDs:
                if let value: [AudioObjectID] = getQualifiedArrayValue(from: qtype) {
                    return "[" + value.map { $0 != kAudioObjectUnknown ? "@\($0)" : "<null>" }.joined(separator: ", ") + "]"
                }
            case .string:
                if let value: CFString = getQualifiedValue(from: qtype) {
                    return "\(value)"
                }

            default:
                break
            }

        default:
            return nil
        }
        

        return nil
    }
}
