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
    
    //===========================================================
    // UI
    //===========================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var width  = self.view?.frame.width
        var height = self.view?.frame.height
        
        println("\(width) * \(height)")
        println(_charaImageView.frame)
        
        //_charaImageView.frame = CGRectMake(0, 0, height!, width!)
        
        _bgImageView = makeImageView(CGRectMake(0, 0, height!, width!), _charaImageView.image!)
        _charaImageView.hidden = true
        _bgImageView?.sizeToFit()
        self.view.addSubview(_bgImageView!)
    }
    
    override func viewWillAppear(animated: Bool) {
        //_charaImageView.sizeToFit()
        /*
        var width  = self.view?.frame.width
        var height = self.view?.frame.height
        
        println("\(width) * \(height)")
        println(_charaImageView.frame)
        
        _charaImageView.frame = CGRectMake(0, 0, height!, width!)
*/
    }
    
    override func viewDidAppear(animated: Bool) {
        _charaImageView.sizeToFit()
        /*
        var width  = self.view?.frame.width
        var height = self.view?.frame.height
        
        _charaImageView.frame = CGRectMake(0, 0, height!, width!)
*/
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        _charaImageView.sizeToFit()
        
        delay(2.0, {
            /*
            var width  = self.view?.frame.width
            var height = self.view?.frame.height
            
            self._charaImageView.frame = CGRectMake(0, 0, height!, width!)*/
    
        })
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            var t: UITouch = touch as UITouch
            
            println(t.view.tag)
            
            if t.view.tag == 20 {
                NSLog("player touched")
                if _soundPlayer.isVoicePlaying() {
                    _soundPlayer.pauseVoice()
                } else {
                    _soundPlayer.resumeVoice()
                }
            } else {
                //_playerImageView.hidden = !_playerImageView.hidden
            }
        }
    }


}