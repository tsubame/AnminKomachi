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
    
    // ls or pr
    var _imageType = "ls"
    //
    var _imageNumFormat = "%02d"
    
    // プレイヤー表示用画像
    var _coverImage = UIImage(named: "maid_sleep.jpg")
    //
    var _imageIndex = 0
    
    @IBOutlet weak var _coverImageView: UIImageView!

    @IBOutlet weak var _playerImageView: UIImageView!
    
    var _bgImageView: UIImageView?
    
    //
    func playSample() {
        var file = "頭痛にナファリン"
        file = "こころをリラックス。"
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
    
    // 画像を変更
    func changeImage() {
        _imageIndex++
        let maxID = 30
        
        var indexStr = NSString(format: _imageNumFormat, _imageIndex)
        //println(indexStr)
        
        var fileName = "cover_\(_imageType)_" + indexStr // + ".jpg"
        println(fileName)
        
        var coverImage = makeUIImage(fileName)
        println(coverImage)
        
        if coverImage != nil {
            _coverImage = coverImage!
            let coverImageView = makeImageView(CGRectMake(0, 0, 320, 640), _coverImage!)
            _coverImageView.frame = self.view.frame
            _coverImageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            changeCoverImageWithFade(coverImage!)

            showPlayingInfo()
        } else {
            if maxID <= _imageIndex {
                _imageIndex = 0
                println("画像がありません。")
            } else {
                changeImage()
            }
        }
    }
    
    func changeCoverImageWithFade(image: UIImage) {
        UIView.transitionWithView(_coverImageView,
            duration: 1.0,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: {
                self._coverImageView.image = image
            },
            completion: {
                finished in
        })
    }
    
    // ファイル名を受け取り、UIImageのインスタンスを返す。
    func makeUIImage(file: String) -> UIImage? {
        // 拡張子を補う
        let fileName = supplySuffix(file)
        println(fileName)
        
        // ファイルがなければnilを返す
        var path = NSBundle.mainBundle().pathForResource(fileName, ofType: "")
        if path == nil {
            //_errorCode = SoundPlayerErrorCode.FileNotFound
            var errorMessage = "=== error! === ファイルがありません！: " + fileName + "\n"
            println(errorMessage)
            
            return nil
        }
        
        return UIImage(named: fileName)
    }
    
    // ファイル名に拡張子を補う
    func supplySuffix(fileName: String) -> String {
        // 画像ファイルの拡張子が無い場合に付ける拡張子
        let IMAGE_SUFFIXES = [".png", ".gif", ".jpg"]
        
        // 拡張子があるか？
        var loc = (fileName as NSString).rangeOfString(".").location
        if loc == NSNotFound {
            for suffix in IMAGE_SUFFIXES {
                var fileNameWithSuffix = fileName + suffix
                var path = NSBundle.mainBundle().pathForResource(fileNameWithSuffix, ofType: "")
                
                if path != nil {
                    //println("拡張子" + suffix + "を追加しました")
                    return fileNameWithSuffix
                }
            }
        }
        
        return fileName
    }
    
    //===========================================================
    // UI
    //===========================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        

        /*
        _bgImageView = makeImageView(CGRectMake(0, 0, 320, 640), _coverImage!)
        _bgImageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(_bgImageView!)
*/
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
            
            if t.view.tag == _playerImageView.tag {
                NSLog("player touched")
                if _soundPlayer.isVoicePlaying() {
                    _soundPlayer.pauseVoice()
                } else {
                    _soundPlayer.resumeVoice()
                }
            } else {
                var loc = t.locationInView(self.view)
                println(loc)
                if loc.y < 100 {
                    changeImage()
                } else {
                    _playerImageView.hidden = !_playerImageView.hidden
                }
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