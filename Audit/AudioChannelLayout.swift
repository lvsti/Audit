//
//  AudioChannelLayout.swift
//  Audit
//
//  Created by Tamás Lustyik on 2019. 02. 16..
//  Copyright © 2019. Tamas Lustyik. All rights reserved.
//

import Foundation
import CoreAudio
import CoreAudio.CoreAudioTypes

extension AudioChannelLayout: CustomDebugStringConvertible {
    public var debugDescription: String {
        var this = self
        let rawDescs = UnsafeBufferPointer<AudioChannelDescription>(start: &this.mChannelDescriptions,
                                                                    count: Int(mNumberChannelDescriptions))
        let descs = "\n        " + rawDescs.map(debugDescriptionForChannelDescription).joined(separator: ",\n        ") + "\n"
        
        return """
            AudioChannelLayout {
                tag: \(debugDescriptionForLayoutTag(mChannelLayoutTag)),
                bitmap: \(debugDescriptionForChannelBitmap(mChannelBitmap)),
                descriptions: [\(descs)]
            """
    }

    private func debugDescriptionForLayoutTag(_ tag: AudioChannelLayoutTag) -> String {
        return "\(tag)"
    }

    private func debugDescriptionForChannelBitmap(_ bitmap: AudioChannelBitmap) -> String {
        let bits: [AudioChannelBitmap] = [
            .bit_Left,
            .bit_Right,
            .bit_Center,
            .bit_LFEScreen,
            .bit_LeftSurround,
            .bit_RightSurround,
            .bit_LeftCenter,
            .bit_RightCenter,
            .bit_CenterSurround,
            .bit_LeftSurroundDirect,
            .bit_RightSurroundDirect,
            .bit_TopCenterSurround,
            .bit_VerticalHeightLeft,
            .bit_VerticalHeightCenter,
            .bit_VerticalHeightRight,
            .bit_TopBackLeft,
            .bit_TopBackCenter,
            .bit_TopBackRight
        ]
        
        let names = [
            "Left",
            "Right",
            "Center",
            "LFEScreen",
            "LeftSurround",
            "RightSurround",
            "LeftCenter",
            "RightCenter",
            "CenterSurround",
            "LeftSurroundDirect",
            "RightSurroundDirect",
            "TopCenterSurround",
            "VerticalHeightLeft",
            "VerticalHeightCenter",
            "VerticalHeightRight",
            "TopBackLeft",
            "TopBackCenter",
            "TopBackRight"
        ]
        
        return "[" + bits.enumerated()
            .filter { bitmap.contains($0.element) }
            .map { names[$0.offset] }
            .joined(separator: ", ") + "]"
    }
    
    private func debugDescriptionForChannelDescription(_ desc: AudioChannelDescription) -> String {
        let coordType = desc.mChannelFlags.contains(.rectangularCoordinates) ? "rectangular" : "spherical"
        let unitType = desc.mChannelFlags.contains(.meters) ? "meters" : "fraction"
        
        return "AudioChannelDescription {\n" +
            "    label: \(desc.mChannelLabel) (0x\(String(desc.mChannelLabel, radix: 16, uppercase: true))),\n" +
            "    flags: [\(coordType), \(unitType)],\n" +
            "    coords: (\(desc.mCoordinates.0), \(desc.mCoordinates.1), \(desc.mCoordinates.2))\n" +
            "}"
    }
}

