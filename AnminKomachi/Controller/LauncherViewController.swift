//
//  LauncherViewController.swift
//  AnminKomachi
//
//  Created by hideki on 2015/01/06.
//  Copyright (c) 2015年 Tsubaki. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer
//import Realm

class LauncherViewController: UIViewController {

    var _player = SoundPlayer()
    
    //@IBOutlet weak var _bgBlackOut: UIView!
    
    var _mediaPlayer: MPMoviePlayerController? = nil
    
    //@IBOutlet weak var _outlineLabel: UIOutlineLabel!
    
    //var _outlineLabel = UIOutlineLabel()

    var _fadeLabel :FadeLabel = FadeLabel()
    //var _l: UIOutlineLabel?
    
    @IBOutlet weak var _outlineLabel: UILabel!
    
    
    // セグエ
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == nil {
            return
        }
        
        let id = segue.identifier!
        var pref = NSUserDefaults.standardUserDefaults()
        
        if id == "ls" {
            /*
            UIView.transitionWithView(_bgBlackOut,
                duration: 0.5,
                options: UIViewAnimationOptions.TransitionCrossDissolve,
                animations: {
                    self._bgBlackOut.hidden = false
                },
                completion: {
                    finished in
            })*/
            
            pref.setObject("landscape", forKey: "orientation")
            pref.synchronize()
        } else {
            pref.setObject("portrait", forKey: "orientation")
            pref.synchronize()
        }
    }
    
    // 画面遷移 戻り
    @IBAction func returnToHome(segue: UIStoryboardSegue) {
        println("return")
        //UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        NSUserDefaults.standardUserDefaults().setObject("portrait", forKey: "orientation")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        /*
        UIView.transitionWithView(_bgBlackOut,
            duration: 0.5,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: {
                self._bgBlackOut.hidden = true
            },
            completion: {
                finished in
        })*/
    }
    
    
    func playEnvSE() {
        
        var path = NSBundle.mainBundle().pathForResource("river", ofType: "mp3")
        let url  = NSURL.fileURLWithPath(path!)
        _mediaPlayer = MPMoviePlayerController(contentURL: url)
        _mediaPlayer?.shouldAutoplay = false
        _mediaPlayer?.controlStyle = MPMovieControlStyle.Embedded
        _mediaPlayer?.prepareToPlay()
        _mediaPlayer?.play()
        showPlayingInfo()
    }
    
    func pauseEnvSE() {
        _mediaPlayer?.pause()
    }
    
    func showPlayingInfo() {
        var albumArt = MPMediaItemArtwork(image: UIImage(named: "ささら.png"))
        
        let mpic = MPNowPlayingInfoCenter.defaultCenter()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyTitle:  "川の音",
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
        
        let oth = AVAudioSession.sharedInstance().otherAudioPlaying
        println("other audio playing: \(oth)")
        
        var or = NSUserDefaults.standardUserDefaults().stringForKey("orientation")
        println("画面の向き: " + or!)
        
        var aText = NSMutableAttributedString(string: "我が名は龍の魂を継ぎし者、ユーマ！\n龍鳴剣ヴァンデルホーンよ！")
        
        // 文字間の調節
        aText.addAttribute(NSKernAttributeName, value: 1.7, range: NSMakeRange(0, aText.length))
        // 行間の調節
        let pStyle = NSMutableParagraphStyle()
        pStyle.lineSpacing = 12
        aText.addAttribute(NSParagraphStyleAttributeName, value: pStyle, range: NSMakeRange(0, aText.length))
        
        _fadeLabel = FadeLabel(frame: CGRectMake(30, 30, 350, 150))
        _fadeLabel.numberOfLines = 5
        _fadeLabel.outlineSize = 2.5
        //_fadeLabel.font = UIFont(name: "azuki_font", size: 18)
        _fadeLabel.font = UIFont(name: ".HiraKakuInterface-W6", size: 18)
        _fadeLabel.textColor = UIColor.whiteColor()
        _fadeLabel.outlineColor = UIColor.darkGrayColor()
        _fadeLabel.attributedText = aText
        // テキストのグローエフェクト
        _fadeLabel.layer.shadowColor   = UIColor.blackColor().CGColor
        _fadeLabel.layer.shadowRadius  = 3.0
        _fadeLabel.layer.shadowOpacity = 0.3
        _fadeLabel.layer.shadowOffset  = CGSizeZero
        _fadeLabel.layer.masksToBounds = false
        
        self.view.addSubview(_fadeLabel)
        
        
        
        
        _outlineLabel.textColor = UIColor.blackColor()
        _outlineLabel.font = UIFont(name: "azuki_font", size: 18)
        //_outlineLabel.shadowColor = UIColor.blackColor()
        //_outlineLabel.shadowOffset = CGSizeMake(0, 1.0)
        
        
        _outlineLabel.layer.shadowColor   = UIColor.blackColor().CGColor
        _outlineLabel.layer.shadowRadius  = 4.0
        _outlineLabel.layer.shadowOpacity = 0.9
        _outlineLabel.layer.shadowOffset  = CGSizeZero
        _outlineLabel.layer.masksToBounds = false
        
        println(UIScreen.mainScreen().bounds)
    }
    
    // 回転の許可
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    /*
    // FirstResponderDelegate
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if self.canBecomeFirstResponder() {
            self.becomeFirstResponder()
            UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
            println("1stレスポンダーになりました。")
            //playEnvSE()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {

        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        let rc = event.subtype
        //let p = self.player.player
        println("received remote control \(rc.rawValue)") // 101 = pause, 100 = play
        
        switch rc {
            case .RemoteControlTogglePlayPause:
                println("toggle play pause.")
                break
            case .RemoteControlPlay:
                playEnvSE()
                break
            case .RemoteControlPause:
                println("pause.")
                pauseEnvSE()
                break
            default:
                break
        }
        
    }*/
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if self.isFirstResponder() {
                        //playEnvSE()
            //println("1stレスポンダーだよ")
        }
    }
}

