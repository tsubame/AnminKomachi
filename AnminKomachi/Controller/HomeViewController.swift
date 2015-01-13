//
//  ViewController.swift
//  AnminKomachi
//
//  Created by hideki on 2014/12/24.
//  Copyright (c) 2014年 Tsubaki. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var _animator:UIDynamicAnimator = UIDynamicAnimator()
    
    var _nextView: UIView = UIView()
    
    @IBOutlet weak var _slimeImageView: UIImageView!
    
    @IBOutlet weak var _playerImageView: UIImageView!
    //var _animationView =
    
    func gravityTest() {
        //_playerImageView.hidden = false
        _playerImageView.frame = CGRectMake(_playerImageView.frame.origin.x, 0, _playerImageView.bounds.width, _playerImageView.bounds.height)
        
        _slimeImageView.hidden = false
        _slimeImageView.frame = CGRectMake(_slimeImageView.frame.origin.x, 0, _slimeImageView.bounds.width, _slimeImageView.bounds.height)
        
        _animator = UIDynamicAnimator(referenceView: self.view)
        var gravity = UIGravityBehavior(items: [_playerImageView, _slimeImageView])
        gravity.magnitude = 3.0
        _animator.addBehavior(gravity)
        var collisionLine: CGFloat = 400
        var collisionBehavior = UICollisionBehavior(items: [_playerImageView])

        collisionBehavior.addBoundaryWithIdentifier("bottom", fromPoint: CGPointMake(0, collisionLine), toPoint: CGPointMake(300, collisionLine))
        //collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        _animator.addBehavior(collisionBehavior)
        
        var collisionBehavior2 = UICollisionBehavior(items: [_slimeImageView])
        collisionBehavior2.translatesReferenceBoundsIntoBoundary = true
        _animator.addBehavior(collisionBehavior2)
    }
    
    // アクション
    @IBAction func onButtonClicked(sender: AnyObject) {
        gravityTest()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == nil {
            return
        }
        
        let id = segue.identifier!
        var pref = NSUserDefaults.standardUserDefaults()
        
        if id == "sleepLsSeque" {
            //println("選択キャラがありません。初期データとして \(selectedChara) を登録します")
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
    }
    
    //===========================================================
    // UI
    //===========================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gravityTest()
    }
    
    // 回転の許可
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    /*
    override func supportedInterfaceOrientations() -> Int {
        println("回転可能な向きを通知")
        return UIInterfaceOrientation.Portrait.rawValue;
    }*/

}

