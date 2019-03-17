//
//  ObjectDescription.swift
//  Audit
//
//  Created by Tamás Lustyik on 2019. 03. 17..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio
import HALKit

extension AudioClass {
    static func name(for classID: AudioClassID) -> String {
        switch classID {
        case AudioClass.system: return "SystemObject"
        case AudioClass.object: return "Object"
        case AudioClass.plugIn: return "PlugIn"
        case AudioClass.transportManager: return "TransportManager"
        case AudioClass.box: return "Box"
        case AudioClass.device: return "Device"
        case AudioClass.clockDevice: return "ClockDevice"
        case AudioClass.endPointDevice: return "EndPointDevice"
        case AudioClass.endPoint: return "EndPoint"
        case AudioClass.stream: return "Stream"
        case AudioClass.aggregateDevice: return "AggregateDevice"
        case AudioClass.subDevice: return "SubDevice"
        case AudioClass.control: return "Control"
        case AudioClass.sliderControl: return "SliderControl"
        case AudioClass.levelControl: return "LevelControl"
        case AudioClass.volumeControl: return "VolumeControl"
        case AudioClass.lfeVolumeControl: return "LFEVolumeControl"
        case AudioClass.bootChimeVolumeControl: return "BootChimeControl"
        case AudioClass.booleanControl: return "BooleanControl"
        case AudioClass.muteControl: return "MuteControl"
        case AudioClass.soloControl: return "SoloControl"
        case AudioClass.jackControl: return "JackControl"
        case AudioClass.lfeMuteControl: return "LFEMuteControl"
        case AudioClass.phantomPowerControl: return "PhantomPowerControl"
        case AudioClass.phaseInvertControl: return "PhaseInvertControl"
        case AudioClass.clipLightControl: return "ClipLightControl"
        case AudioClass.talkbackControl: return "TalkbackControl"
        case AudioClass.listenbackControl: return "ListenbackControl"
        case AudioClass.iSubOwnerControl: return "ISubOwnerControl"
        case AudioClass.donzControl: return "DONZControl"
        case AudioClass.evisControl: return "EVISControl"
        case AudioClass.selectorControl: return "SelectorControl"
        case AudioClass.dataSourceControl: return "DataSourceControl"
        case AudioClass.dataDestinationControl: return "DataDestinationControl"
        case AudioClass.clockSourceControl: return "ClockSourceControl"
        case AudioClass.lineLevelControl: return "LineLevelControl"
        case AudioClass.highPassFilterControl: return "HighPassFilterControl"
        case AudioClass.stereoPanControl: return "StereoPanControl"
        default: return "Object"
        }
    }
}
