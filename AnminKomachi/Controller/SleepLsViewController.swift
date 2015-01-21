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

class SleepLsViewController: UIViewController {
    
    var _soundPlayer = SoundPlayer()
    
    // プレイヤー表示用画像
    var _coverImage = UIImage(named: "maid_sleep.jpg")
    //
    var _imageIndex = 0
    // ls or pr
    var _imageType = "ls"
    //
    var _imageNumFormat = "%03d"
    
    //var _bgImageView: UIImageView?
    
    var _orientation = "landscape"

    @IBOutlet weak var _bgImageView: UIImageView!
    
    //
    func playSample() {
        var file = "頭痛にナファリン"
        file = "たんぽぽの綿毛"
        _soundPlayer.playVoice(file)
        showPlayingInfo()
        println("音声を流します")
    }
    
    // プレイヤーに情報を表示
    func showPlayingInfo() {
        var albumArt = MPMediaItemArtwork(image: _coverImage)
        let mpic = MPNowPlayingInfoCenter.defaultCenter()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyTitle:  "安眠ボイス",
            MPMediaItemPropertyArtist: "安眠小町",
            MPMediaItemPropertyArtwork: albumArt
        ]
    }
    
    // 画像の変更
    func changeImage() {
        _imageIndex++
        //
        var indexStr = NSString(format: _imageNumFormat, _imageIndex)
        //
        var fileName = "cover_\(_imageType)_" + indexStr + ".jpg"
        println(fileName)
        
        let bgImage = UIImage(named: fileName)
        
        if bgImage == nil {
            println("画像がありません。")
            _imageIndex = 0
            changeImage()
        } else {
            let aspect = calcImgAspect(bgImage)
            // 画像の横幅 画面の縦幅と同じ
            let imageWidth = UIScreen.mainScreen().bounds.size.height
            // 画像の縦幅
            let imageHeight = UIScreen.mainScreen().bounds.size.width //imageWidth / aspect
            _bgImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight)
            println("imageViewのサイズ: \(_bgImageView.frame)")
            changeImageWithFade(bgImage!)
            showPlayingInfo()
        }
    }
    
    func changeImageWithFade(image: UIImage) {
        UIView.transitionWithView(self.view, //_bgImageView,
            duration: 1.0,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: {
                self._bgImageView.image = image
            },
            completion: {
                finished in
        })
    }
    
    // 画像のアスペクト比を 横 / 縦 の比率で返す
    func calcImgAspect(image: UIImage?) -> CGFloat {
        if let tmpImg = image {
            
            let imSize  = tmpImg.size
            println("画像のサイズ: \(imSize)")
            let width   = imSize.width
            let height  = imSize.height
            let aspect  = width / height
            
            return aspect
        } else {
            return 0.0
        }
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
    
    // 1stレスポンダー
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // 回転の許可
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // タッチ
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            var t: UITouch = touch as UITouch
            
            //println(t.view.tag)
            var loc = t.locationInView(self.view)
            println(loc)
            if 250 < loc.y {
                changeImage()
            } else {
                //_playerImageView.hidden = !_playerImageView.hidden
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