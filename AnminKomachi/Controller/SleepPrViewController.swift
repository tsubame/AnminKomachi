//
//  SleepPrViewController.swift
//  AnminKomachi
//
//  Created by hideki on 2014/12/24.
//  Copyright (c) 2014年 Tsubaki. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import UIKit

class SleepPrViewController: UIViewController {
    
    var _soundPlayer = SoundPlayer()
    
    @IBOutlet weak var _playerImageView: UIImageView!
    
    func playSample() {
        var file = "頭痛にナファリン"
        file = "こころをリラックス。"
        _soundPlayer.playVoice(file)
        showPlayingInfo()
    }
    
    // プレイヤーに情報を表示
    func showPlayingInfo() {
        var albumArt = MPMediaItemArtwork(image: UIImage(named: "maid_sleep.jpg"))
        let mpic = MPNowPlayingInfoCenter.defaultCenter()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyTitle:  "安眠ボイス",
            MPMediaItemPropertyArtist: "安眠小町",
            MPMediaItemPropertyArtwork: albumArt
        ]
        //println(MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo)
    }
    
    //===========================================================
    // UI
    //===========================================================

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 1stレスポンダーに
        if self.canBecomeFirstResponder() {
            self.becomeFirstResponder()
            UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
            playSample()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    // 回転の許可
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // タッチ
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
    
    //===========================================================
    // RemoteControl
    //===========================================================
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        println(event)
        
        if (event.type == UIEventType.RemoteControl) {
            
            switch event.subtype {
                case UIEventSubtype.RemoteControlPlay:
                    println("Play")
                    _soundPlayer.resumeVoice()
                    break
                case UIEventSubtype.RemoteControlPause:
                    println("Pause")
                    _soundPlayer.pauseVoice()
                    break
                case UIEventSubtype.RemoteControlTogglePlayPause:
                    println("PlayPause")
                    break
                default:
                    break
            }
        }
    }
    

    
}