//
//  SleepLsViewController.swift
//  AnminKomachi
//
//  Created by hideki on 2014/12/24.
//  Copyright (c) 2014年 Tsubaki. All rights reserved.
//

import Foundation
import UIKit

class SleepLsViewController: UIViewController {

    var _soundPlayer = SoundPlayer()
    
    @IBOutlet weak var _charaImageView: UIImageView!
    
    var _bgImageView: UIImageView?
    
    @IBOutlet weak var _playerImageView: UIImageView!
    
    @IBAction func _dismissButtonClicked(sender: AnyObject) {
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //===========================================================
    // UI
    //===========================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        var file = "いっしょにねよう？"
        _soundPlayer.playVoice(file)
        //if (UIViewController.classFallbacksForKeyedArchiver()) // iOS8 has this class only
        //{
        //UIDevice.currentDevice().setValue(UIDeviceOrientation.LandscapeRight.rawValue, forKey: "orientation")
            //[[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        //}
    }
    
    // 回転の許可 AppDelegateで指定する場合はfalseにすること
    override func shouldAutorotate() -> Bool {
        return false
    }

    // これを書くとエラーになる？
    /*
    override func supportedInterfaceOrientations() -> Int {
        println("回転可能な向きを通知")
        return UIInterfaceOrientation.LandscapeRight.rawValue;
    }*/

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            var t: UITouch = touch as UITouch
            
            println(t.view.tag)
            
            if t.view.tag == _playerImageView.tag {
                NSLog("player touched")
                if _soundPlayer.isVoicePlaying() {
                    _soundPlayer.pauseVoice()
                } else {
                    _soundPlayer.resumeVoice()
                }
            } else {
                _playerImageView.hidden = !_playerImageView.hidden
            }
        }
    }


}