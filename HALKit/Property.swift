//
//  PropertyType.swift
//  Cameo
//
//  Created by Tamás Lustyik on 2019. 01. 05..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio


enum HALKitError: Error {
    case missingQualifier
    case missingInputValue
    case invalidOperation
    case halError(OSStatus)
}

public enum PropertyReadSemantics {
    /// value written to provided buffer
    case read
    
    /// value in provided buffer is used, result is written back to buffer (in/out types are the same)
    case mutatingRead
    
    /// value in provided buffer is used, no result is written
    case inboundOnly
    
    /// value in provided buffer is used, no result is written but the status code of the operation may be of interest
    case inboundOnlyWithStatus
    
    /// special case of `mutatingRead`: an AudioValueTranslation object is provided with the input
    /// and returned in place with the output
    case translation(PropertyType, PropertyType)
    
    /// data in the qualifier is used, result is written to provided buffer
    case qualifiedRead(PropertyType)
    
    /// data in the qualifier is used if any, result is written to provided buffer
    case optionallyQualifiedRead(PropertyType)
}

public enum PropertyType {
    case boolean32, uint32, float32, float64, fourCC,
        classID, objectID,
        audioChannelLayout, audioStreamBasicDescription, audioValueRange,
        pid,
        ioProcStreamUsage, audioValueTranslation, audioBufferList,
        cString
    case arrayOfObjectIDs, arrayOfStreamIDs, arrayOfClassIDs, arrayOfAudioValueRanges,
        arrayOfUInt32s, arrayOfAudioStreamRangedDescriptions, arrayOfAudioStreamBasicDescriptions
    case string, url, dictionary, runLoop
    case arrayOfStrings
}

public enum AudioObjectProperty {
    public enum Scope {
        public static let global = AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal)
        public static let any = AudioObjectPropertyScope(kAudioObjectPropertyScopeWildcard)
        public static let deviceInput = AudioObjectPropertyScope(kAudioDevicePropertyScopeInput)
        public static let deviceOutput = AudioObjectPropertyScope(kAudioDevicePropertyScopeOutput)
        public static let devicePlayThrough = AudioObjectPropertyScope(kAudioDevicePropertyScopePlayThrough)
    }
    
    public enum Element {
        public static let master = AudioObjectPropertyElement(kAudioObjectPropertyElementMaster)
        public static let any = AudioObjectPropertyElement(kAudioObjectPropertyElementWildcard)
    }
}

public extension AudioObjectPropertyAddress {
    init(_ selector: AudioObjectPropertySelector,
         _ scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
         _ element: AudioObjectPropertyElement = AudioObjectProperty.Element.any) {
        self.init(mSelector: selector, mScope: scope, mElement: element)
    }
}

public protocol Property {
    var selector: AudioObjectPropertySelector { get }
    var type: PropertyType { get }
    var readSemantics: PropertyReadSemantics { get }
}

public protocol PropertySet: Property, CaseIterable {
    static func allExisting(scope: AudioObjectPropertyScope,
                            element: AudioObjectPropertyElement,
                            in objectID: AudioObjectID) -> [Self]
}

public extension PropertySet {
    static func allExisting(scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                            element: AudioObjectPropertyElement = AudioObjectProperty.Element.any,
                            in objectID: AudioObjectID) -> [Self] {
        return allCases.filter { $0.exists(in: objectID, scope: scope, element: element) }
    }
}

public extension Property {
    public func show(in objectID: AudioObjectID) {
        AudioObjectShow(objectID)
    }
    
    public func exists(in objectID: AudioObjectID,
                       scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                       element: AudioObjectPropertyElement = AudioObjectProperty.Element.any) -> Bool {
        var address = AudioObjectPropertyAddress(selector, scope, element)
        
        return AudioObjectHasProperty(objectID, &address)
    }
    
    public func isSettable(in objectID: AudioObjectID,
                           scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                           element: AudioObjectPropertyElement = AudioObjectProperty.Element.any) -> Bool {
        var address = AudioObjectPropertyAddress(selector, scope, element)
        
        var isSettable: DarwinBoolean = false
        
        let status = AudioObjectIsPropertySettable(objectID, &address, &isSettable)
        guard status == kAudioHardwareNoError else {
            return false
        }
        
        return isSettable.boolValue
    }

    public func value<T>(in objectID: AudioObjectID,
                         scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                         element: AudioObjectPropertyElement = AudioObjectProperty.Element.any,
                         for inputValue: T? = nil,
                         qualifiedBy qualifier: QualifierProtocol? = nil) throws -> T {
        switch readSemantics {
        case .qualifiedRead where qualifier == nil: throw HALKitError.missingQualifier
        case .translation, .mutatingRead, .inboundOnly, .inboundOnlyWithStatus:
            if inputValue == nil {
                throw HALKitError.missingInputValue
            }
        default: break
        }

        var address = AudioObjectPropertyAddress(selector, scope, element)
        var dataSize = UInt32(MemoryLayout<T>.size)
        var data = UnsafeMutableRawPointer.allocate(byteCount: Int(dataSize), alignment: MemoryLayout<T>.alignment)
        defer { data.deallocate() }
        if let inputValue = inputValue {
            data.assumingMemoryBound(to: T.self).pointee = inputValue
        }

        let status = AudioObjectGetPropertyData(objectID, &address,
                                                UInt32(qualifier?.size ?? 0), qualifier?.data,
                                                &dataSize, data)
        guard status == kAudioHardwareNoError else {
            throw HALKitError.halError(status)
        }

        let typedData = data.bindMemory(to: T.self, capacity: 1)
        return typedData.pointee
    }
    
    public func arrayValue<T>(in objectID: AudioObjectID,
                              scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                              element: AudioObjectPropertyElement = AudioObjectProperty.Element.any,
                              for inputValue: [T]? = nil,
                              qualifiedBy qualifier: QualifierProtocol? = nil) throws -> [T] {
        switch readSemantics {
        case .qualifiedRead where qualifier == nil: throw HALKitError.missingQualifier
        case .translation, .mutatingRead, .inboundOnly, .inboundOnlyWithStatus:
            if inputValue == nil {
                throw HALKitError.missingInputValue
            }
        default: break
        }

        var address = AudioObjectPropertyAddress(selector, scope, element)
        var dataSize: UInt32 = 0
        
        var status = AudioObjectGetPropertyDataSize(objectID, &address,
                                                    UInt32(qualifier?.size ?? 0), qualifier?.data,
                                                    &dataSize)
        guard status == kAudioHardwareNoError else {
            throw HALKitError.halError(status)
        }
        
        let count = Int(dataSize) / MemoryLayout<T>.size
        var data = UnsafeMutableRawPointer.allocate(byteCount: Int(dataSize), alignment: MemoryLayout<T>.alignment)
        defer { data.deallocate() }
        let typedData = data.bindMemory(to: T.self, capacity: count)
        
        if let inputValue = inputValue {
            for index in 0 ..< min(count, inputValue.count) {
                typedData.advanced(by: index).pointee = inputValue[index]
            }
        }

        status = AudioObjectGetPropertyData(objectID, &address,
                                            UInt32(qualifier?.size ?? 0), qualifier?.data,
                                            &dataSize, data)
        guard status == kAudioHardwareNoError else {
            throw HALKitError.halError(status)
        }
        
        return UnsafeBufferPointer<T>(start: typedData, count: count).map { $0 }
    }
    
    public func setValue<T>(_ value: T,
                            in objectID: AudioObjectID,
                            scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                            element: AudioObjectPropertyElement = AudioObjectProperty.Element.any,
                            qualifiedBy qualifier: QualifierProtocol? = nil) throws {
        var address = AudioObjectPropertyAddress(selector, scope, element)
        let dataSize = UInt32(MemoryLayout<T>.size)
        var value = value
        
        let status = AudioObjectSetPropertyData(objectID, &address,
                                               UInt32(qualifier?.size ?? 0), qualifier?.data,
                                               dataSize, &value)

        guard status == kAudioHardwareNoError else {
            throw HALKitError.halError(status)
        }
    }
    
    public func setArrayValue<T>(_ value: [T],
                                 in objectID: AudioObjectID,
                                 scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                                 element: AudioObjectPropertyElement = AudioObjectProperty.Element.any,
                                 qualifiedBy qualifier: QualifierProtocol? = nil) throws {
        var address = AudioObjectPropertyAddress(selector, scope, element)
        let dataSize = UInt32(MemoryLayout<T>.size * value.count)
        var value = value

        let status = AudioObjectSetPropertyData(objectID, &address,
                                                UInt32(qualifier?.size ?? 0), qualifier?.data,
                                                dataSize, &value)

        guard status == kAudioHardwareNoError else {
            throw HALKitError.halError(status)
        }
    }

    public func translateValue<T, U>(_ value: T,
                                     in objectID: AudioObjectID,
                                     scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                                     element: AudioObjectPropertyElement = AudioObjectProperty.Element.any) throws -> U {
        guard case .translation = readSemantics else {
            throw HALKitError.invalidOperation
        }
        
        var address = AudioObjectPropertyAddress(selector, scope, element)
        var dataSize = UInt32(MemoryLayout<AudioValueTranslation>.size)
        var value = value
        var translatedValue = UnsafeMutablePointer<U>.allocate(capacity: 1)
        defer { translatedValue.deallocate() }
        
        var translation = AudioValueTranslation(mInputData: &value,
                                                mInputDataSize: UInt32(MemoryLayout<T>.size),
                                                mOutputData: translatedValue,
                                                mOutputDataSize: UInt32(MemoryLayout<U>.size))
        
        let status = AudioObjectGetPropertyData(objectID, &address,
                                                0, nil,
                                                &dataSize,
                                                &translation)
        guard status == kAudioHardwareNoError else {
            throw HALKitError.halError(status)
        }
        
        return translatedValue.pointee
    }

    public func addListener(in objectID: AudioObjectID,
                            scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                            element: AudioObjectPropertyElement = AudioObjectProperty.Element.any,
                            queue: DispatchQueue? = nil,
                            block: @escaping ([AudioObjectPropertyAddress]) -> Void) throws -> PropertyListener {
        let address = AudioObjectPropertyAddress(selector, scope, element)
        
        return try PropertyListenerImpl(objectID: objectID, address: address, queue: queue) { addressCount, addressPtr in
            guard addressCount > 0 else { return }
            block(UnsafeBufferPointer(start: addressPtr, count: Int(addressCount)).map { $0 })
        }
    }
    
    public func removeListener(_ listener: PropertyListener) -> Bool {
        guard let listener = listener as? PropertyListenerImpl else {
            return false
        }
        
        return listener.deactivate()
    }
    
    public func dataSize(in objectID: AudioObjectID,
                         scope: AudioObjectPropertyScope = AudioObjectProperty.Scope.any,
                         element: AudioObjectPropertyElement = AudioObjectProperty.Element.any,
                         qualifiedBy qualifier: QualifierProtocol? = nil) throws -> Int {
        switch readSemantics {
        case .qualifiedRead where qualifier == nil: throw HALKitError.missingQualifier
        default: break
        }
        
        var address = AudioObjectPropertyAddress(selector, scope, element)
        var dataSize: UInt32 = 0
        
        let status = AudioObjectGetPropertyDataSize(objectID, &address,
                                                    UInt32(qualifier?.size ?? 0), qualifier?.data,
                                                    &dataSize)
        guard status == kAudioHardwareNoError else {
            throw HALKitError.halError(status)
        }
        
        return Int(dataSize)
    }
}

public protocol PropertyListener {}

class PropertyListenerImpl: PropertyListener {
    private let objectID: AudioObjectID
    private let address: AudioObjectPropertyAddress
    private let queue: DispatchQueue?
    private let block: AudioObjectPropertyListenerBlock
    private var isActive: Bool
    
    init(objectID: AudioObjectID,
         address: AudioObjectPropertyAddress,
         queue: DispatchQueue?,
         block: @escaping AudioObjectPropertyListenerBlock) throws {
        self.objectID = objectID
        self.address = address
        self.queue = queue
        self.block = block
        
        var address = address
        let status = AudioObjectAddPropertyListenerBlock(objectID, &address, queue, block)
        guard status == kAudioHardwareNoError else {
            throw HALKitError.halError(status)
        }
        
        isActive = true
    }
    
    @discardableResult
    func deactivate() -> Bool {
        guard isActive else { return true }
        
        var address = self.address
        let status = AudioObjectRemovePropertyListenerBlock(objectID, &address, queue, block)
        guard status == kAudioHardwareNoError else {
            return false
        }
        
        isActive = false
        return true
    }
    
    deinit {
        if isActive {
            deactivate()
        }
    }
}
