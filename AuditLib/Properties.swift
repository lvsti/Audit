//
//  Properties.swift
//  AuditLib
//
//  Created by Tamás Lustyik on 2019. 02. 15..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio

public enum ObjectProperty: PropertySetInternal {
    case baseClass, `class`, owner, name, modelName, manufacturer,
        elementName, elementCategoryName, elementNumberName,
        ownedObjects, identify, serialNumber, firmwareVersion
    
    static let descriptors: [ObjectProperty: PropertyDescriptor] = [
        .baseClass: PropertyDescriptor(kAudioObjectPropertyBaseClass, .classID),
        .class: PropertyDescriptor(kAudioObjectPropertyClass, .classID),
        .owner: PropertyDescriptor(kAudioObjectPropertyOwner, .objectID),
        .name: PropertyDescriptor(kAudioObjectPropertyName, .string),
        .modelName: PropertyDescriptor(kAudioObjectPropertyModelName, .string),
        .manufacturer: PropertyDescriptor(kAudioObjectPropertyManufacturer, .string),
        .elementName: PropertyDescriptor(kAudioObjectPropertyElementName, .string),
        .elementCategoryName: PropertyDescriptor(kAudioObjectPropertyElementCategoryName, .string),
        .elementNumberName: PropertyDescriptor(kAudioObjectPropertyElementNumberName, .string),
        .ownedObjects: PropertyDescriptor(kAudioObjectPropertyOwnedObjects, .arrayOfObjectIDs, .optionallyQualifiedRead(.arrayOfClassIDs)),
        .identify: PropertyDescriptor(kAudioObjectPropertyIdentify, .boolean32),
        .serialNumber: PropertyDescriptor(kAudioObjectPropertySerialNumber, .string),
        .firmwareVersion: PropertyDescriptor(kAudioObjectPropertyFirmwareVersion, .string)
    ]
}

public enum PlugInProperty: PropertySetInternal {
    case bundleID, deviceList, translateUIDToDevice, boxList, translateUIDToBox,
        clockDeviceList, translateUIDToClockDevice

    static let descriptors: [PlugInProperty: PropertyDescriptor] = [
        .bundleID: PropertyDescriptor(kAudioPlugInPropertyBundleID, .string),
        .deviceList: PropertyDescriptor(kAudioPlugInPropertyDeviceList, .arrayOfObjectIDs),
        .translateUIDToDevice: PropertyDescriptor(kAudioPlugInPropertyTranslateUIDToDevice, .objectID, .qualifiedRead(.string)),
        .boxList: PropertyDescriptor(kAudioPlugInPropertyBoxList, .arrayOfObjectIDs),
        .translateUIDToBox: PropertyDescriptor(kAudioPlugInPropertyTranslateUIDToBox, .objectID, .qualifiedRead(.string)),
        .clockDeviceList: PropertyDescriptor(kAudioPlugInPropertyClockDeviceList, .arrayOfObjectIDs),
        .translateUIDToClockDevice: PropertyDescriptor(kAudioPlugInPropertyTranslateUIDToClockDevice, .objectID, .qualifiedRead(.string))
    ]
}

public enum TransportManagerProperty: PropertySetInternal {
    case endPointList, translateUIDToEndPoint, transportType
    
    static let descriptors: [TransportManagerProperty: PropertyDescriptor] = [
        .endPointList: PropertyDescriptor(kAudioTransportManagerPropertyEndPointList, .arrayOfObjectIDs),
        .translateUIDToEndPoint: PropertyDescriptor(kAudioTransportManagerPropertyTranslateUIDToEndPoint, .objectID, .qualifiedRead(.string)),
        .transportType: PropertyDescriptor(kAudioTransportManagerPropertyTransportType, .fourCC),
    ]
}

public enum BoxProperty: PropertySetInternal {
    case boxUID, transportType, hasAudio, hasVideo, hasMIDI, isProtected,
        acquired, acquisitionFailed, deviceList, clockDeviceList
    
    static let descriptors: [BoxProperty: PropertyDescriptor] = [
        .boxUID: PropertyDescriptor(kAudioBoxPropertyBoxUID, .string),
        .transportType: PropertyDescriptor(kAudioBoxPropertyTransportType, .fourCC),
        .hasAudio: PropertyDescriptor(kAudioBoxPropertyHasAudio, .boolean32),
        .hasVideo: PropertyDescriptor(kAudioBoxPropertyHasVideo, .boolean32),
        .hasMIDI: PropertyDescriptor(kAudioBoxPropertyHasMIDI, .boolean32),
        .isProtected: PropertyDescriptor(kAudioBoxPropertyIsProtected, .boolean32),
        .acquired: PropertyDescriptor(kAudioBoxPropertyAcquired, .boolean32),
        .acquisitionFailed: PropertyDescriptor(kAudioBoxPropertyAcquisitionFailed, .uint32),
        .deviceList: PropertyDescriptor(kAudioBoxPropertyDeviceList, .arrayOfObjectIDs),
        .clockDeviceList: PropertyDescriptor(kAudioBoxPropertyClockDeviceList, .arrayOfObjectIDs),
    ]
}

public enum DeviceProperty: PropertySetInternal {
    case configurationApplication, deviceUID, modelUID, transportType, relatedDevices, clockDomain,
        deviceIsAlive, deviceIsRunning, deviceCanBeDefaultDevice, deviceCanBeDefaultSystemDevice,
        latency, streams, controlList, safetyOffset,
        nominalSampleRate, availableNominalSampleRates,
        icon, isHidden,
        preferredChannelsForStereo, preferredChannelLayout

    static let descriptors: [DeviceProperty: PropertyDescriptor] = [
        .configurationApplication: PropertyDescriptor(kAudioDevicePropertyConfigurationApplication, .string),
        .deviceUID: PropertyDescriptor(kAudioDevicePropertyDeviceUID, .string),
        .modelUID: PropertyDescriptor(kAudioDevicePropertyModelUID, .string),
        .transportType: PropertyDescriptor(kAudioDevicePropertyTransportType, .fourCC),
        .relatedDevices: PropertyDescriptor(kAudioDevicePropertyRelatedDevices, .arrayOfObjectIDs),
        .clockDomain: PropertyDescriptor(kAudioDevicePropertyClockDomain, .uint32),
        .deviceIsAlive: PropertyDescriptor(kAudioDevicePropertyDeviceIsAlive, .boolean32),
        .deviceIsRunning: PropertyDescriptor(kAudioDevicePropertyDeviceIsRunning, .boolean32),
        .deviceCanBeDefaultDevice: PropertyDescriptor(kAudioDevicePropertyDeviceCanBeDefaultDevice, .boolean32),
        .deviceCanBeDefaultSystemDevice: PropertyDescriptor(kAudioDevicePropertyDeviceCanBeDefaultSystemDevice, .boolean32),
        .latency: PropertyDescriptor(kAudioDevicePropertyLatency, .uint32),
        .streams: PropertyDescriptor(kAudioDevicePropertyStreams, .arrayOfStreamIDs),
        .controlList: PropertyDescriptor(kAudioObjectPropertyControlList, .arrayOfObjectIDs),
        .safetyOffset: PropertyDescriptor(kAudioDevicePropertySafetyOffset, .uint32),
        .nominalSampleRate: PropertyDescriptor(kAudioDevicePropertyNominalSampleRate, .float64),
        .availableNominalSampleRates: PropertyDescriptor(kAudioDevicePropertyAvailableNominalSampleRates, .arrayOfAudioValueRanges),
        .icon: PropertyDescriptor(kAudioDevicePropertyIcon, .url),
        .isHidden: PropertyDescriptor(kAudioDevicePropertyIsHidden, .boolean32),
        .preferredChannelsForStereo: PropertyDescriptor(kAudioDevicePropertyPreferredChannelsForStereo, .arrayOfUInt32s),
        .preferredChannelLayout: PropertyDescriptor(kAudioDevicePropertyPreferredChannelLayout, .audioChannelLayout)
    ]
}

public enum ClockDeviceProperty: PropertySetInternal {
    case deviceUID, transportType, clockDomain, deviceIsAlive, deviceIsRunning,
        latency, controlList, nominalSampleRate, availableNominalSampleRates
    
    static let descriptors: [ClockDeviceProperty: PropertyDescriptor] = [
        .deviceUID: PropertyDescriptor(kAudioClockDevicePropertyDeviceUID, .objectID),
        .transportType: PropertyDescriptor(kAudioClockDevicePropertyTransportType, .objectID),
        .clockDomain: PropertyDescriptor(kAudioClockDevicePropertyClockDomain, .objectID),
        .deviceIsAlive: PropertyDescriptor(kAudioClockDevicePropertyDeviceIsAlive, .objectID),
        .deviceIsRunning: PropertyDescriptor(kAudioClockDevicePropertyDeviceIsRunning, .objectID),
        .latency: PropertyDescriptor(kAudioClockDevicePropertyLatency, .objectID),
        .controlList: PropertyDescriptor(kAudioClockDevicePropertyControlList, .objectID),
        .nominalSampleRate: PropertyDescriptor(kAudioClockDevicePropertyNominalSampleRate, .objectID),
        .availableNominalSampleRates: PropertyDescriptor(kAudioClockDevicePropertyAvailableNominalSampleRates, .objectID),
    ]
}

public enum EndPointDeviceProperty: PropertySetInternal {
    case composition, endPointList, isPrivate
    
    static let descriptors: [EndPointDeviceProperty: PropertyDescriptor] = [
        .composition: PropertyDescriptor(kAudioEndPointDevicePropertyComposition, .fourCC),
        .endPointList: PropertyDescriptor(kAudioEndPointDevicePropertyEndPointList, .fourCC),
        .isPrivate: PropertyDescriptor(kAudioEndPointDevicePropertyIsPrivate, .fourCC)
    ]
}

public enum StreamProperty: PropertySetInternal {
    case isActive, direction, terminalType, startingChannel, latency,
        virtualFormat, availableVirtualFormats, physicalFormat, availablePhysicalFormats
    
    static let descriptors: [StreamProperty: PropertyDescriptor] = [
        .isActive: PropertyDescriptor(kAudioStreamPropertyIsActive, .boolean32),
        .direction: PropertyDescriptor(kAudioStreamPropertyDirection, .uint32),
        .terminalType: PropertyDescriptor(kAudioStreamPropertyTerminalType, .fourCC),
        .startingChannel: PropertyDescriptor(kAudioStreamPropertyStartingChannel, .uint32),
        .latency: PropertyDescriptor(kAudioStreamPropertyLatency, .uint32),
        .virtualFormat: PropertyDescriptor(kAudioStreamPropertyVirtualFormat, .audioStreamBasicDescription),
        .availableVirtualFormats: PropertyDescriptor(kAudioStreamPropertyAvailableVirtualFormats, .arrayOfAudioStreamRangedDescriptions),
        .physicalFormat: PropertyDescriptor(kAudioStreamPropertyPhysicalFormat, .audioStreamBasicDescription),
        .availablePhysicalFormats: PropertyDescriptor(kAudioStreamPropertyAvailablePhysicalFormats, .arrayOfAudioStreamRangedDescriptions)
    ]
}

public enum ControlProperty: PropertySetInternal {
    case scope, element
    
    static let descriptors: [ControlProperty: PropertyDescriptor] = [
        .scope: PropertyDescriptor(kAudioControlPropertyScope, .fourCC),
        .element: PropertyDescriptor(kAudioControlPropertyElement, .fourCC)
    ]
}

public enum SliderControlProperty: PropertySetInternal {
    case value, range
    
    static let descriptors: [SliderControlProperty: PropertyDescriptor] = [
        .value: PropertyDescriptor(kAudioSliderControlPropertyValue, .uint32),
        .range: PropertyDescriptor(kAudioSliderControlPropertyRange, .arrayOfUInt32s)
    ]
}

public enum LevelControlProperty: PropertySetInternal {
    case scalarValue, decibelValue, decibelRange, convertScalarToDecibels, convertDecibelsToScalar
    
    static let descriptors: [LevelControlProperty: PropertyDescriptor] = [
        .scalarValue: PropertyDescriptor(kAudioLevelControlPropertyScalarValue, .float32),
        .decibelValue: PropertyDescriptor(kAudioLevelControlPropertyDecibelValue, .float32),
        .decibelRange: PropertyDescriptor(kAudioLevelControlPropertyDecibelRange, .audioValueRange),
        .convertScalarToDecibels: PropertyDescriptor(kAudioLevelControlPropertyConvertScalarToDecibels, .float32, .translation(.float32, .float32)),
        .convertDecibelsToScalar: PropertyDescriptor(kAudioLevelControlPropertyConvertDecibelsToScalar, .float32, .translation(.float32, .float32))
    ]
}

public enum BooleanControlProperty: PropertySetInternal {
    case value
    
    static let descriptors: [BooleanControlProperty: PropertyDescriptor] = [
        .value: PropertyDescriptor(kAudioBooleanControlPropertyValue, .boolean32)
    ]
}

public enum SelectorControlProperty: PropertySetInternal {
    case currentItem, availableItems, itemName, itemKind
    
    static let descriptors: [SelectorControlProperty: PropertyDescriptor] = [
        .currentItem: PropertyDescriptor(kAudioSelectorControlPropertyCurrentItem, .arrayOfUInt32s),
        .availableItems: PropertyDescriptor(kAudioSelectorControlPropertyAvailableItems, .arrayOfUInt32s),
        .itemName: PropertyDescriptor(kAudioSelectorControlPropertyItemName, .string, .qualifiedRead(.uint32)),
        .itemKind: PropertyDescriptor(kAudioSelectorControlPropertyItemKind, .uint32, .qualifiedRead(.uint32)),
    ]
}

public enum StereoPanControlProperty: PropertySetInternal {
    case value, panningChannels
    
    static let descriptors: [StereoPanControlProperty: PropertyDescriptor] = [
        .value: PropertyDescriptor(kAudioStereoPanControlPropertyValue, .float32),
        .panningChannels: PropertyDescriptor(kAudioStereoPanControlPropertyValue, .arrayOfUInt32s)
    ]
}



struct PropertyDescriptor: Property {
    let selector: AudioObjectPropertySelector
    let type: PropertyType
    let readSemantics: PropertyReadSemantics
    
    init(_ selector: UInt32, _ type: PropertyType, _ readSemantics: PropertyReadSemantics = .read) {
        self.selector = AudioObjectPropertySelector(selector)
        self.type = type
        self.readSemantics = readSemantics
    }
}

protocol PropertySetInternal: PropertySet, Hashable {
    static var descriptors: [Self: PropertyDescriptor] { get }
}

extension PropertySetInternal {
    public var selector: AudioObjectPropertySelector {
        return Self.descriptors[self]!.selector
    }
    
    public var type: PropertyType {
        return Self.descriptors[self]!.type
    }
    
    public var readSemantics: PropertyReadSemantics {
        return Self.descriptors[self]!.readSemantics
    }
}
