//
//  Object.swift
//  HALKit
//
//  Created by Tamás Lustyik on 2019. 02. 15..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio

public enum AudioObject {
    public static let system = AudioObjectID(kAudioObjectSystemObject)
    public static let unknown = AudioObjectID(kAudioObjectUnknown)
}

public enum AudioClass {
    public static let system = AudioClassID(kAudioSystemObjectClassID)
    public static let object = AudioClassID(kAudioObjectClassID)
    public static let plugIn = AudioClassID(kAudioPlugInClassID)
    public static let transportManager = AudioClassID(kAudioTransportManagerClassID)
    
    static let pluginClassIDs: Set<AudioClassID> = [
        AudioClass.transportManager
    ]
    public static let box = AudioClassID(kAudioBoxClassID)
    public static let device = AudioClassID(kAudioDeviceClassID)
    public static let clockDevice = AudioClassID(kAudioClockDeviceClassID)
    public static let endPointDevice = AudioClassID(kAudioEndPointDeviceClassID)
    public static let endPoint = AudioClassID(kAudioEndPointClassID)
    public static let stream = AudioClassID(kAudioStreamClassID)
    public static let aggregateDevice = AudioClassID(kAudioAggregateDeviceClassID)
    public static let subDevice = AudioClassID(kAudioSubDeviceClassID)
    
    static let deviceClassIDs: Set<AudioClassID> = [
        AudioClass.endPointDevice,
        AudioClass.endPoint,
        AudioClass.aggregateDevice,
        AudioClass.subDevice
    ]

    public static let control = AudioClassID(kAudioControlClassID)
    
    public static let sliderControl = AudioClassID(kAudioSliderControlClassID)
    
    public static let levelControl = AudioClassID(kAudioLevelControlClassID)
    public static let volumeControl = AudioClassID(kAudioVolumeControlClassID)
    public static let lfeVolumeControl = AudioClassID(kAudioLFEVolumeControlClassID)
    public static let bootChimeVolumeControl = AudioClassID(kAudioBootChimeVolumeControlClassID)

    static let levelControlClassIDs: Set<AudioClassID> = [
        AudioClass.volumeControl,
        AudioClass.lfeVolumeControl,
        AudioClass.bootChimeVolumeControl
    ]

    public static let booleanControl = AudioClassID(kAudioBooleanControlClassID)
    public static let muteControl = AudioClassID(kAudioMuteControlClassID)
    public static let soloControl = AudioClassID(kAudioSoloControlClassID)
    public static let jackControl = AudioClassID(kAudioJackControlClassID)
    public static let lfeMuteControl = AudioClassID(kAudioLFEMuteControlClassID)
    public static let phantomPowerControl = AudioClassID(kAudioPhantomPowerControlClassID)
    public static let phaseInvertControl = AudioClassID(kAudioPhaseInvertControlClassID)
    public static let clipLightControl = AudioClassID(kAudioClipLightControlClassID)
    public static let talkbackControl = AudioClassID(kAudioTalkbackControlClassID)
    public static let listenbackControl = AudioClassID(kAudioListenbackControlClassID)
    public static let iSubOwnerControl = AudioClassID(kAudioISubOwnerControlClassID)
    public static let donzControl = AudioClassID(0x646F6E7A) // 'donz'
    public static let evisControl = AudioClassID(0x65766973) // 'evis'

    static let booleanControlClassIDs: Set<AudioClassID> = [
        AudioClass.muteControl,
        AudioClass.soloControl,
        AudioClass.jackControl,
        AudioClass.lfeMuteControl,
        AudioClass.phantomPowerControl,
        AudioClass.phaseInvertControl,
        AudioClass.clipLightControl,
        AudioClass.talkbackControl,
        AudioClass.listenbackControl,
        AudioClass.iSubOwnerControl,
        
        AudioClass.donzControl,
        AudioClass.evisControl
    ]

    public static let selectorControl = AudioClassID(kAudioSelectorControlClassID)
    public static let dataSourceControl = AudioClassID(kAudioDataSourceControlClassID)
    public static let dataDestinationControl = AudioClassID(kAudioDataDestinationControlClassID)
    public static let clockSourceControl = AudioClassID(kAudioClockSourceControlClassID)
    public static let lineLevelControl = AudioClassID(kAudioLineLevelControlClassID)
    public static let highPassFilterControl = AudioClassID(kAudioHighPassFilterControlClassID)

    static let selectorControlClassIDs: Set<AudioClassID> = [
        AudioClass.dataSourceControl,
        AudioClass.dataDestinationControl,
        AudioClass.clockSourceControl,
        AudioClass.lineLevelControl,
        AudioClass.highPassFilterControl
    ]
    
    public static let stereoPanControl = AudioClassID(kAudioStereoPanControlClassID)

}

public extension AudioClassID {
    public func isSubclass(of baseClassID: AudioClassID) -> Bool {
        switch baseClassID {
        case AudioClass.object: return true
            
        case AudioClass.plugIn:
            return self == baseClassID || AudioClass.pluginClassIDs.contains(self)
            
        case AudioClass.device:
            return self == baseClassID || AudioClass.deviceClassIDs.contains(self)

        case AudioClass.control:
            switch self {
            case AudioClass.control, AudioClass.sliderControl, AudioClass.levelControl,
                 AudioClass.booleanControl, AudioClass.selectorControl, AudioClass.stereoPanControl:
                return true
            case _ where AudioClass.levelControlClassIDs.contains(self):
                return true
            case _ where AudioClass.booleanControlClassIDs.contains(self):
                return true
            case _ where AudioClass.selectorControlClassIDs.contains(self):
                return true
            default:
                return false
            }

        case AudioClass.levelControl:
            return self == AudioClass.levelControl || AudioClass.levelControlClassIDs.contains(self)

        case AudioClass.booleanControl:
            return self == AudioClass.booleanControl || AudioClass.booleanControlClassIDs.contains(self)
            
        case AudioClass.selectorControl:
            return self == AudioClass.selectorControl || AudioClass.selectorControlClassIDs.contains(self)
            
        default: return self == baseClassID
        }
    }
}
