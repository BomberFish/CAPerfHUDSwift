// bomberfish
// CADebugCommon.swift – CAPerfHudSwift
// created on 2023-12-18

import Darwin
import Foundation
import QuartzCore
import SwiftUI

// pretty much a swift rewrite of https://github.com/khanhduytran0/CAPerfHUD/blob/main/Common/CADebugCommon.m

let CA_DEBUG_OPTION_PERF_HUD: Int32 = 0x24
let RLTD_LAZY: Int32 = 0x1
let RLTD_NOW: Int32 = 0x2

// thanks https://bryce.co/on-device-render-debugging/ for a full swift implementation
typealias getDebugOptType = @convention(c) (
    Int32, Int32) -> Int32

typealias getDebugValType = @convention(c) (
    Int32, Int32) -> Int32

typealias setDebugOptType = @convention(c) (
    Int32, Int32, Int32) -> Void

typealias setDebugValType = @convention(c) (
    Int32, Int32, Int32) -> Void

let CARenderServerGetDebugOption = unsafeBitCast(dlsym(dlopen("/System/Library/Frameworks/QuartzCore.framework/QuartzCore", RLTD_NOW), "CARenderServerGetDebugOption"), to: getDebugOptType.self)
let CARenderServerGetDebugValue = unsafeBitCast(dlsym(dlopen("/System/Library/Frameworks/QuartzCore.framework/QuartzCore", RLTD_NOW), "CARenderServerGetDebugValue"), to: getDebugOptType.self)

let CARenderServerSetDebugOption = unsafeBitCast(dlsym(dlopen("/System/Library/Frameworks/QuartzCore.framework/QuartzCore", RLTD_NOW), "CARenderServerSetDebugOption"), to: setDebugOptType.self)
let CARenderServerSetDebugValue = unsafeBitCast(dlsym(dlopen("/System/Library/Frameworks/QuartzCore.framework/QuartzCore", RLTD_NOW), "CARenderServerSetDebugValue"), to: setDebugOptType.self)

public struct CADebugCommon {
    static let perfHUDLevelNames = ["Off", "Basic", "Backdrop", "Particles", "Full", "Frequencies", "Power", "FPS only", "Display", "Glitches"]
    static func getPerfHUDLevel() -> Int32 {
        if CARenderServerGetDebugOption(0, CA_DEBUG_OPTION_PERF_HUD) == 0 {
            return 0
        }
        return CARenderServerGetDebugValue(0, 1)+1;
    }

    static func setPerfHUDLevel(_ level: Int32) {
        CARenderServerSetDebugOption(0, CA_DEBUG_OPTION_PERF_HUD, level)
        if level > 0 {
            CARenderServerSetDebugValue(0, 1, level-1)
        }
    }
    
    static var perfHUDLevel: Binding<Int32> {
        Binding<Int32>(
            get: { getPerfHUDLevel() },
            set: { setPerfHUDLevel($0) }
        )
    }
}
