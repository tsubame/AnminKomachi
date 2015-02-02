//
//  main.swift
//  AnminKomachi
//
//  Created by hideki on 2015/01/18.
//  Copyright (c) 2015年 Tsubaki. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioToolbox

println("起動します")

let fileName = "コイン"

//AudioServicesPlaySystemSound(SystemSoundID(1008))

// ファイルがなければnilを返す
var path = NSBundle.mainBundle().pathForResource(fileName, ofType: "m4a")

println(path)

if path != nil {

    let url  = NSURL.fileURLWithPath(path!)
    
    var soundID:SystemSoundID = 0
    AudioServicesCreateSystemSoundID(url, &soundID)
    AudioServicesPlaySystemSound(soundID)
    
    //NSThread.sleepForTimeInterval(0.3)
} else {
    println("サウンドファイルがありません")
}
//_errorCode = SoundPlayerErrorCode.NoError
//_errorMessage = nil

exit(UIApplicationMain(C_ARGC, C_ARGV, nil, "AnminKomachi.AppDelegate"))