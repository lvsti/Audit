//
//  Properties.swift
//  HALKit
//
//  Created by Tamás Lustyik on 2019. 02. 15..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio
import CoreAudio.AudioServerPlugIn

public enum ObjectProperty: PropertySetInternal {
    case creator, baseClass, `class`, owner, name, modelName, manufacturer,
        elementName, elementCategoryName, elementNumberName,
        ownedObjects, identify, serialNumber, firmwareVersion
    
    static let descriptors: [ObjectProperty: PropertyDescriptor] = [
        .creator: PropertyDescriptor(kAudioObjectPropertyCreator, .string),
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

public enum SystemProperty: PropertySetInternal {
    case devices, defaultInputDevice, defaultOutputDevice, defaultSystemOutputDevice, translateUIDToDevice,
        mixStereoToMono, plugInList, translateBundleIDToPlugIn, transportManagerList,
        translateBundleIDToTransportManager, boxList, translateUIDToBox, clockDeviceList,
        translateUIDToClockDevice, processIsMaster, isInitingOrExiting, userIDChanged, processIsAudible,
        sleepingIsAllowed, unloadingIsAllowed, hogModeIsAllowed, userSessionIsActiveOrHeadless,
        serviceRestarted, powerHint
    
    static let descriptors: [SystemProperty: PropertyDescriptor] = [
        .devices: PropertyDescriptor(kAudioHardwarePropertyDevices, .arrayOfObjectIDs),
        .defaultInputDevice: PropertyDescriptor(kAudioHardwarePropertyDefaultInputDevice, .objectID),
        .defaultOutputDevice: PropertyDescriptor(kAudioHardwarePropertyDefaultOutputDevice, .objectID),
        .defaultSystemOutputDevice: PropertyDescriptor(kAudioHardwarePropertyDefaultSystemOutputDevice, .objectID),
        .translateUIDToDevice: PropertyDescriptor(kAudioHardwarePropertyTranslateUIDToDevice, .objectID, .qualifiedRead(.string)),
        .mixStereoToMono: PropertyDescriptor(kAudioHardwarePropertyMixStereoToMono, .boolean32),
        .plugInList: PropertyDescriptor(kAudioHardwarePropertyPlugInList, .arrayOfObjectIDs),
        .translateBundleIDToPlugIn: PropertyDescriptor(kAudioHardwarePropertyTranslateBundleIDToPlugIn, .objectID, .qualifiedRead(.string)),
        .transportManagerList: PropertyDescriptor(kAudioHardwarePropertyTransportManagerList, .arrayOfObjectIDs),
        .translateBundleIDToTransportManager: PropertyDescriptor(kAudioHardwarePropertyTranslateBundleIDToTransportManager, .objectID, .qualifiedRead(.string)),
        .boxList: PropertyDescriptor(kAudioHardwarePropertyBoxList, .arrayOfObjectIDs),
        .translateUIDToBox: PropertyDescriptor(kAudioHardwarePropertyTranslateUIDToBox, .objectID, .qualifiedRead(.string)),
        .clockDeviceList: PropertyDescriptor(kAudioHardwarePropertyClockDeviceList, .arrayOfObjectIDs),
        .translateUIDToClockDevice: PropertyDescriptor(kAudioHardwarePropertyTranslateUIDToClockDevice, .objectID, .qualifiedRead(.string)),
        .processIsMaster: PropertyDescriptor(kAudioHardwarePropertyProcessIsMaster, .boolean32),
        .isInitingOrExiting: PropertyDescriptor(kAudioHardwarePropertyIsInitingOrExiting, .boolean32),
        .userIDChanged: PropertyDescriptor(kAudioHardwarePropertyUserIDChanged, .uint32),
        .processIsAudible: PropertyDescriptor(kAudioHardwarePropertyProcessIsAudible, .boolean32),
        .sleepingIsAllowed: PropertyDescriptor(kAudioHardwarePropertySleepingIsAllowed, .boolean32),
        .unloadingIsAllowed: PropertyDescriptor(kAudioHardwarePropertyUnloadingIsAllowed, .boolean32),
        .hogModeIsAllowed: PropertyDescriptor(kAudioHardwarePropertyHogModeIsAllowed, .boolean32),
        .userSessionIsActiveOrHeadless: PropertyDescriptor(kAudioHardwarePropertyUserSessionIsActiveOrHeadless, .boolean32),
        .serviceRestarted: PropertyDescriptor(kAudioHardwarePropertyServiceRestarted, .uint32),
        .powerHint: PropertyDescriptor(kAudioHardwarePropertyPowerHint, .uint32)
    ]
}

public enum SystemProperty_Deprecated: PropertySetInternal {
    case runLoop, deviceForUID, plugInForBundleID
    
    case bootChimeVolumeScalar, bootChimeVolumeDecibels, bootChimeVolumeRangeDecibels,
        bootChimeVolumeScalarToDecibels, bootChimeVolumeDecibelsToScalar,
        bootChimeVolumeDecibelsToScalarTransferFunction
    
    static let descriptors: [SystemProperty_Deprecated: PropertyDescriptor] = [
        .runLoop: PropertyDescriptor(kAudioHardwarePropertyRunLoop, .runLoop),
        .deviceForUID: PropertyDescriptor(kAudioHardwarePropertyDeviceForUID, .audioValueTranslation, .translation(.string, .objectID)),
        .plugInForBundleID: PropertyDescriptor(kAudioHardwarePropertyPlugInForBundleID, .audioValueTranslation, .translation(.string, .objectID)),
        
        .bootChimeVolumeScalar: PropertyDescriptor(kAudioHardwarePropertyBootChimeVolumeScalar, .float32),
        .bootChimeVolumeDecibels: PropertyDescriptor(kAudioHardwarePropertyBootChimeVolumeDecibels, .float32),
        .bootChimeVolumeRangeDecibels: PropertyDescriptor(kAudioHardwarePropertyBootChimeVolumeRangeDecibels, .float32),
        .bootChimeVolumeScalarToDecibels: PropertyDescriptor(kAudioHardwarePropertyBootChimeVolumeScalarToDecibels, .float32),
        .bootChimeVolumeDecibelsToScalar: PropertyDescriptor(kAudioHardwarePropertyBootChimeVolumeDecibelsToScalar, .float32),
        .bootChimeVolumeDecibelsToScalarTransferFunction: PropertyDescriptor(kAudioHardwarePropertyBootChimeVolumeDecibelsToScalarTransferFunction, .float32),
    ]
}

public enum PlugInProperty: PropertySetInternal {
    case bundleID, deviceList, translateUIDToDevice, boxList, translateUIDToBox,
        clockDeviceList, translateUIDToClockDevice
    case createAggregateDevice, destroyAggregateDevice
    case resourceBundle

    static let descriptors: [PlugInProperty: PropertyDescriptor] = [
        .bundleID: PropertyDescriptor(kAudioPlugInPropertyBundleID, .string),
        .deviceList: PropertyDescriptor(kAudioPlugInPropertyDeviceList, .arrayOfObjectIDs),
        .translateUIDToDevice: PropertyDescriptor(kAudioPlugInPropertyTranslateUIDToDevice, .objectID, .qualifiedRead(.string)),
        .boxList: PropertyDescriptor(kAudioPlugInPropertyBoxList, .arrayOfObjectIDs),
        .translateUIDToBox: PropertyDescriptor(kAudioPlugInPropertyTranslateUIDToBox, .objectID, .qualifiedRead(.string)),
        .clockDeviceList: PropertyDescriptor(kAudioPlugInPropertyClockDeviceList, .arrayOfObjectIDs),
        .translateUIDToClockDevice: PropertyDescriptor(kAudioPlugInPropertyTranslateUIDToClockDevice, .objectID, .qualifiedRead(.string)),
        
        .createAggregateDevice: PropertyDescriptor(kAudioPlugInCreateAggregateDevice, .objectID, .qualifiedRead(.dictionary)),
        .destroyAggregateDevice: PropertyDescriptor(kAudioPlugInDestroyAggregateDevice, .objectID, .inboundOnly),
        
        .resourceBundle: PropertyDescriptor(kAudioPlugInPropertyResourceBundle, .string)
    ]
}

public enum TransportManagerProperty: PropertySetInternal {
    case endPointList, translateUIDToEndPoint, transportType
    case createEndPointDevice, destroyEndPointDevice
    
    static let descriptors: [TransportManagerProperty: PropertyDescriptor] = [
        .endPointList: PropertyDescriptor(kAudioTransportManagerPropertyEndPointList, .arrayOfObjectIDs),
        .translateUIDToEndPoint: PropertyDescriptor(kAudioTransportManagerPropertyTranslateUIDToEndPoint, .objectID, .qualifiedRead(.string)),
        .transportType: PropertyDescriptor(kAudioTransportManagerPropertyTransportType, .fourCC),
        .createEndPointDevice: PropertyDescriptor(kAudioTransportManagerCreateEndPointDevice, .objectID, .qualifiedRead(.dictionary)),
        .destroyEndPointDevice: PropertyDescriptor(kAudioTransportManagerDestroyEndPointDevice, .objectID, .inboundOnly),
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
    
    case plugIn, deviceHasChanged, deviceIsRunningSomewhere, processorOverload, ioStoppedAbnormally,
        hogMode, bufferFrameSize, bufferFrameSizeRange, usesVariableBufferFrameSizes, ioCycleUsage,
        streamConfiguration, ioProcStreamUsage, actualSampleRate, clockDevice
    
    case jackIsConnected, volumeScalar, volumeDecibels, volumeRangeDecibels, volumeScalarToDecibels,
        volumeDecibelsToScalar, stereoPan, stereoPanChannels, mute, solo, phantomPower, phaseInvert,
        clipLight, talkback, listenback, dataSource, dataSources, dataSourceNameForIDCFString,
        dataSourceKindForID, clockSource, clockSources, clockSourceNameForIDCFString, clockSourceKindForID,
        playThru, playThruSolo, playThruVolumeScalar, playThruVolumeDecibels, playThruVolumeRangeDecibels,
        playThruVolumeScalarToDecibels, playThruVolumeDecibelsToScalar, playThruStereoPan,
        playThruStereoPanChannels, playThruDestination, playThruDestinations, playThruDestinationNameForIDCFString,
        channelNominalLineLevel, channelNominalLineLevels, channelNominalLineLevelNameForIDCFString,
        highPassFilterSetting, highPassFilterSettings, highPassFilterSettingNameForIDCFString, subVolumeScalar,
        subVolumeDecibels, subVolumeRangeDecibels, subVolumeScalarToDecibels, subVolumeDecibelsToScalar, subMute

    case zeroTimeStampPeriod, clockAlgorithm, clockIsStable
    
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
        .preferredChannelLayout: PropertyDescriptor(kAudioDevicePropertyPreferredChannelLayout, .audioChannelLayout),
        
        .plugIn: PropertyDescriptor(kAudioDevicePropertyPlugIn, .uint32),
        .deviceHasChanged: PropertyDescriptor(kAudioDevicePropertyDeviceHasChanged, .uint32),
        .deviceIsRunningSomewhere: PropertyDescriptor(kAudioDevicePropertyDeviceIsRunningSomewhere, .boolean32),
        .processorOverload: PropertyDescriptor(kAudioDeviceProcessorOverload, .uint32),
        .ioStoppedAbnormally: PropertyDescriptor(kAudioDevicePropertyIOStoppedAbnormally, .uint32),
        .hogMode: PropertyDescriptor(kAudioDevicePropertyHogMode, .pid),
        .bufferFrameSize: PropertyDescriptor(kAudioDevicePropertyBufferFrameSize, .uint32),
        .bufferFrameSizeRange: PropertyDescriptor(kAudioDevicePropertyBufferFrameSizeRange, .audioValueRange),
        .usesVariableBufferFrameSizes: PropertyDescriptor(kAudioDevicePropertyUsesVariableBufferFrameSizes, .uint32),
        .ioCycleUsage: PropertyDescriptor(kAudioDevicePropertyIOCycleUsage, .float32),
        .streamConfiguration: PropertyDescriptor(kAudioDevicePropertyStreamConfiguration, .audioBufferList),
        .ioProcStreamUsage: PropertyDescriptor(kAudioDevicePropertyIOProcStreamUsage, .ioProcStreamUsage, .mutatingRead),
        .actualSampleRate: PropertyDescriptor(kAudioDevicePropertyActualSampleRate, .float64),
        .clockDevice: PropertyDescriptor(kAudioDevicePropertyClockDevice, .string),
        
        .jackIsConnected: PropertyDescriptor(kAudioDevicePropertyJackIsConnected, .boolean32),
        .volumeScalar: PropertyDescriptor(kAudioDevicePropertyVolumeScalar, .float32),
        .volumeDecibels: PropertyDescriptor(kAudioDevicePropertyVolumeDecibels, .float32),
        .volumeRangeDecibels: PropertyDescriptor(kAudioDevicePropertyVolumeRangeDecibels, .audioValueRange),
        .volumeScalarToDecibels: PropertyDescriptor(kAudioDevicePropertyVolumeScalarToDecibels, .float32, .mutatingRead),
        .volumeDecibelsToScalar: PropertyDescriptor(kAudioDevicePropertyVolumeDecibelsToScalar, .float32, .mutatingRead),
        .stereoPan: PropertyDescriptor(kAudioDevicePropertyStereoPan, .float32),
        .stereoPanChannels: PropertyDescriptor(kAudioDevicePropertyStereoPanChannels, .arrayOfUInt32s),
        .mute: PropertyDescriptor(kAudioDevicePropertyMute, .boolean32),
        .solo: PropertyDescriptor(kAudioDevicePropertySolo, .boolean32),
        .phantomPower: PropertyDescriptor(kAudioDevicePropertyPhantomPower, .boolean32),
        .phaseInvert: PropertyDescriptor(kAudioDevicePropertyPhaseInvert, .boolean32),
        .clipLight: PropertyDescriptor(kAudioDevicePropertyClipLight, .boolean32),
        .talkback: PropertyDescriptor(kAudioDevicePropertyTalkback, .boolean32),
        .listenback: PropertyDescriptor(kAudioDevicePropertyListenback, .boolean32),
        .dataSource: PropertyDescriptor(kAudioDevicePropertyDataSource, .arrayOfUInt32s),
        .dataSources: PropertyDescriptor(kAudioDevicePropertyDataSources, .arrayOfUInt32s),
        .dataSourceNameForIDCFString: PropertyDescriptor(kAudioDevicePropertyDataSourceNameForIDCFString, .audioValueTranslation, .translation(.uint32, .string)),
        .dataSourceKindForID: PropertyDescriptor(kAudioDevicePropertyDataSourceKindForID, .audioValueTranslation, .translation(.uint32, .uint32)),
        .clockSource: PropertyDescriptor(kAudioDevicePropertyClockSource, .arrayOfUInt32s),
        .clockSources: PropertyDescriptor(kAudioDevicePropertyClockSources, .arrayOfUInt32s),
        .clockSourceNameForIDCFString: PropertyDescriptor(kAudioDevicePropertyClockSourceNameForIDCFString, .audioValueTranslation, .translation(.uint32, .string)),
        .clockSourceKindForID: PropertyDescriptor(kAudioDevicePropertyClockSourceKindForID, .audioValueTranslation, .translation(.uint32, .uint32)),
        .playThru: PropertyDescriptor(kAudioDevicePropertyPlayThru, .boolean32),
        .playThruSolo: PropertyDescriptor(kAudioDevicePropertyPlayThruSolo, .boolean32),
        .playThruVolumeScalar: PropertyDescriptor(kAudioDevicePropertyPlayThruVolumeScalar, .float32),
        .playThruVolumeDecibels: PropertyDescriptor(kAudioDevicePropertyPlayThruVolumeDecibels, .float32),
        .playThruVolumeRangeDecibels: PropertyDescriptor(kAudioDevicePropertyPlayThruVolumeRangeDecibels, .audioValueRange),
        .playThruVolumeScalarToDecibels: PropertyDescriptor(kAudioDevicePropertyPlayThruVolumeScalarToDecibels, .float32, .mutatingRead),
        .playThruVolumeDecibelsToScalar: PropertyDescriptor(kAudioDevicePropertyPlayThruVolumeDecibelsToScalar, .float32, .mutatingRead),
        .playThruStereoPan: PropertyDescriptor(kAudioDevicePropertyPlayThruStereoPan, .float32),
        .playThruStereoPanChannels: PropertyDescriptor(kAudioDevicePropertyPlayThruStereoPanChannels, .arrayOfUInt32s),
        .playThruDestination: PropertyDescriptor(kAudioDevicePropertyPlayThruDestination, .arrayOfUInt32s),
        .playThruDestinations: PropertyDescriptor(kAudioDevicePropertyPlayThruDestinations, .arrayOfUInt32s),
        .playThruDestinationNameForIDCFString: PropertyDescriptor(kAudioDevicePropertyPlayThruDestinationNameForIDCFString, .audioValueTranslation, .translation(.uint32, .string)),
        .channelNominalLineLevel: PropertyDescriptor(kAudioDevicePropertyChannelNominalLineLevel, .arrayOfUInt32s),
        .channelNominalLineLevels: PropertyDescriptor(kAudioDevicePropertyChannelNominalLineLevels, .arrayOfUInt32s),
        .channelNominalLineLevelNameForIDCFString: PropertyDescriptor(kAudioDevicePropertyChannelNominalLineLevelNameForIDCFString, .audioValueTranslation, .translation(.uint32, .string)),
        .highPassFilterSetting: PropertyDescriptor(kAudioDevicePropertyHighPassFilterSetting, .arrayOfUInt32s),
        .highPassFilterSettings: PropertyDescriptor(kAudioDevicePropertyHighPassFilterSettings, .arrayOfUInt32s),
        .highPassFilterSettingNameForIDCFString: PropertyDescriptor(kAudioDevicePropertyHighPassFilterSettingNameForIDCFString, .audioValueTranslation, .translation(.uint32, .string)),
        .subVolumeScalar: PropertyDescriptor(kAudioDevicePropertySubVolumeScalar, .float32),
        .subVolumeDecibels: PropertyDescriptor(kAudioDevicePropertySubVolumeDecibels, .float32),
        .subVolumeRangeDecibels: PropertyDescriptor(kAudioDevicePropertySubVolumeRangeDecibels, .audioValueRange),
        .subVolumeScalarToDecibels: PropertyDescriptor(kAudioDevicePropertySubVolumeScalarToDecibels, .float32, .mutatingRead),
        .subVolumeDecibelsToScalar: PropertyDescriptor(kAudioDevicePropertySubVolumeDecibelsToScalar, .float32, .mutatingRead),
        .subMute: PropertyDescriptor(kAudioDevicePropertySubMute, .boolean32),
        
        .zeroTimeStampPeriod: PropertyDescriptor(kAudioDevicePropertyZeroTimeStampPeriod, .uint32),
        .clockAlgorithm: PropertyDescriptor(kAudioDevicePropertyClockAlgorithm, .uint32),
        .clockIsStable: PropertyDescriptor(kAudioDevicePropertyClockIsStable, .uint32),
    ]
}

public enum DeviceProperty_Deprecated: PropertySetInternal {
    case volumeDecibelsToScalarTransferFunction, playThruVolumeDecibelsToScalarTransferFunction,
        driverShouldOwniSub, subVolumeDecibelsToScalarTransferFunction
    
    case deviceName, deviceNameCFString, deviceManufacturer, deviceManufacturerCFString, registerBufferList,
        bufferSize, bufferSizeRange, channelName, channelNameCFString, channelCategoryName,
        channelCategoryNameCFString, channelNumberName, channelNumberNameCFString, supportsMixing,
        streamFormat, streamFormats, streamFormatSupported, streamFormatMatch, dataSourceNameForID,
        clockSourceNameForID, playThruDestinationNameForID, channelNominalLineLevelNameForID,
        highPassFilterSettingNameForID
    
    static let descriptors: [DeviceProperty_Deprecated: PropertyDescriptor] = [
        .volumeDecibelsToScalarTransferFunction: PropertyDescriptor(kAudioDevicePropertyVolumeDecibelsToScalarTransferFunction, .uint32),
        .playThruVolumeDecibelsToScalarTransferFunction: PropertyDescriptor(kAudioDevicePropertyPlayThruVolumeDecibelsToScalarTransferFunction, .uint32),
        .driverShouldOwniSub: PropertyDescriptor(kAudioDevicePropertyDriverShouldOwniSub, .boolean32),
        .subVolumeDecibelsToScalarTransferFunction: PropertyDescriptor(kAudioDevicePropertySubVolumeDecibelsToScalarTransferFunction, .uint32),
        
        .deviceName: PropertyDescriptor(kAudioDevicePropertyDeviceName, .cString),
        .deviceNameCFString: PropertyDescriptor(kAudioDevicePropertyDeviceNameCFString, .string),
        .deviceManufacturer: PropertyDescriptor(kAudioDevicePropertyDeviceManufacturer, .cString),
        .deviceManufacturerCFString: PropertyDescriptor(kAudioDevicePropertyDeviceManufacturerCFString, .string),
        .registerBufferList: PropertyDescriptor(kAudioDevicePropertyRegisterBufferList, .audioBufferList),
        .bufferSize: PropertyDescriptor(kAudioDevicePropertyBufferSize, .uint32),
        .bufferSizeRange: PropertyDescriptor(kAudioDevicePropertyBufferSizeRange, .audioValueRange),
        .channelName: PropertyDescriptor(kAudioDevicePropertyChannelName, .cString),
        .channelNameCFString: PropertyDescriptor(kAudioDevicePropertyChannelNameCFString, .string),
        .channelCategoryName: PropertyDescriptor(kAudioDevicePropertyChannelCategoryName, .cString),
        .channelCategoryNameCFString: PropertyDescriptor(kAudioDevicePropertyChannelCategoryNameCFString, .string),
        .channelNumberName: PropertyDescriptor(kAudioDevicePropertyChannelNumberName, .cString),
        .channelNumberNameCFString: PropertyDescriptor(kAudioDevicePropertyChannelNumberNameCFString, .string),
        .supportsMixing: PropertyDescriptor(kAudioDevicePropertySupportsMixing, .boolean32),
        .streamFormat: PropertyDescriptor(kAudioDevicePropertyStreamFormat, .audioStreamBasicDescription),
        .streamFormats: PropertyDescriptor(kAudioDevicePropertyStreamFormats, .arrayOfAudioStreamBasicDescriptions),
        .streamFormatSupported: PropertyDescriptor(kAudioDevicePropertyStreamFormatSupported, .audioStreamBasicDescription, .inboundOnlyWithStatus),
        .streamFormatMatch: PropertyDescriptor(kAudioDevicePropertyStreamFormatMatch, .audioStreamBasicDescription, .mutatingRead),
        .dataSourceNameForID: PropertyDescriptor(kAudioDevicePropertyDataSourceNameForID, .audioValueTranslation, .translation(.uint32, .cString)),
        .clockSourceNameForID: PropertyDescriptor(kAudioDevicePropertyClockSourceNameForID, .audioValueTranslation, .translation(.uint32, .cString)),
        .playThruDestinationNameForID: PropertyDescriptor(kAudioDevicePropertyPlayThruDestinationNameForID, .audioValueTranslation, .translation(.uint32, .cString)),
        .channelNominalLineLevelNameForID: PropertyDescriptor(kAudioDevicePropertyChannelNominalLineLevelNameForID, .audioValueTranslation, .translation(.uint32, .cString)),
        .highPassFilterSettingNameForID: PropertyDescriptor(kAudioDevicePropertyHighPassFilterSettingNameForID, .audioValueTranslation, .translation(.uint32, .cString)),
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

public enum AggregateDeviceProperty: PropertySetInternal {
    case fullSubDeviceList, activeSubDeviceList, composition, masterSubDevice, clockDevice
    
    static let descriptors: [AggregateDeviceProperty: PropertyDescriptor] = [
        .fullSubDeviceList: PropertyDescriptor(kAudioAggregateDevicePropertyFullSubDeviceList, .arrayOfStrings),
        .activeSubDeviceList: PropertyDescriptor(kAudioAggregateDevicePropertyActiveSubDeviceList, .arrayOfObjectIDs),
        .composition: PropertyDescriptor(kAudioAggregateDevicePropertyComposition, .dictionary),
        .masterSubDevice: PropertyDescriptor(kAudioAggregateDevicePropertyMasterSubDevice, .string),
        .clockDevice: PropertyDescriptor(kAudioAggregateDevicePropertyClockDevice, .string),
    ]
}

public enum SubDeviceProperty: PropertySetInternal {
    case extraLatency, driftCompensation, driftCompensationQuality
    
    static let descriptors: [SubDeviceProperty: PropertyDescriptor] = [
        .extraLatency: PropertyDescriptor(kAudioSubDevicePropertyExtraLatency, .float64),
        .driftCompensation: PropertyDescriptor(kAudioSubDevicePropertyDriftCompensation, .boolean32),
        .driftCompensationQuality: PropertyDescriptor(kAudioSubDevicePropertyDriftCompensationQuality, .uint32),
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
        .availablePhysicalFormats: PropertyDescriptor(kAudioStreamPropertyAvailablePhysicalFormats, .arrayOfAudioStreamRangedDescriptions),
    ]
}

public enum StreamProperty_Deprecated: PropertySetInternal {
    case owningDevice, physicalFormats, physicalFormatSupported, physicalFormatMatch
    
    static let descriptors: [StreamProperty_Deprecated: PropertyDescriptor] = [
        .owningDevice: PropertyDescriptor(kAudioStreamPropertyOwningDevice, .objectID),
        .physicalFormats: PropertyDescriptor(kAudioStreamPropertyPhysicalFormats, .arrayOfAudioStreamBasicDescriptions),
        .physicalFormatSupported: PropertyDescriptor(kAudioStreamPropertyPhysicalFormatSupported, .audioStreamBasicDescription, .inboundOnlyWithStatus),
        .physicalFormatMatch: PropertyDescriptor(kAudioStreamPropertyPhysicalFormatMatch, .audioStreamBasicDescription, .mutatingRead),
    ]
}

public enum ControlProperty: PropertySetInternal {
    case scope, element
    
    static let descriptors: [ControlProperty: PropertyDescriptor] = [
        .scope: PropertyDescriptor(kAudioControlPropertyScope, .fourCC),
        .element: PropertyDescriptor(kAudioControlPropertyElement, .uint32),
    ]
}

public enum ControlProperty_Deprecated: PropertySetInternal {
    case variant
    
    static let descriptors: [ControlProperty_Deprecated: PropertyDescriptor] = [
        .variant: PropertyDescriptor(kAudioControlPropertyVariant, .uint32)
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
        .convertScalarToDecibels: PropertyDescriptor(kAudioLevelControlPropertyConvertScalarToDecibels, .float32, .mutatingRead),
        .convertDecibelsToScalar: PropertyDescriptor(kAudioLevelControlPropertyConvertDecibelsToScalar, .float32, .mutatingRead)
    ]
}

public enum LevelControlProperty_Deprecated: PropertySetInternal {
    case decibelsToScalarTransferFunction
    
    static let descriptors: [LevelControlProperty_Deprecated: PropertyDescriptor] = [
        .decibelsToScalarTransferFunction: PropertyDescriptor(kAudioLevelControlPropertyDecibelsToScalarTransferFunction, .uint32)
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
        .panningChannels: PropertyDescriptor(kAudioStereoPanControlPropertyPanningChannels, .arrayOfUInt32s)
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
