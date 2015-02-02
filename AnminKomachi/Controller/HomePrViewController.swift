//
//  HomePrViewController.swift
//  AnminKomachi
//
//  Created by hideki on 2014/12/24.
//  Copyright (c) 2014年 Tsubaki. All rights reserved.
//

import UIKit

class HomePrViewController: UIViewController {
    
    //var _animator:UIDynamicAnimator = UIDynamicAnimator()
    
    var _nextView: UIView = UIView()
    
    var _msgWindowLabel: UILabel!
    
    @IBOutlet weak var _dummyLabel: UILabel!
    
    @IBOutlet weak var _charImageView: UIImageView!
    

    
    var _msgIndex = 0
    
    var _aText = NSMutableAttributedString(string: "ラベル")
    
    @IBOutlet weak var _msgWindowImageView: UIImageView!
    
    var _fadeLabel = FadeLabel()
    
    var _imageType = "pr"


    
    //
    let _imageNameFormat = "cover_pr_"
    //
    let _imageNumFormat = "%02d"
    
    //
    var _imageFileNames = [String]()
    //
    var _imageIndex = 0
    
    // サンプルで表示するテキスト
    let _sampleTexts = [
        "こんばんは。\n今日も1日、お疲れ様でした。",
        "お兄さま、\n今日はどんな日でした？\n良い1日でしたか？",
        "うーん…流石にこの時間になると、眠たいですね。",
        "この時期の話題というと…全豪オープンでしょうか？",
    ]
    
    // 画像ファイルを配列に格納
    func appendImgFileNamesToArray() {
        let maxImgNum = 200
        
        for i in 0...maxImgNum {
            //
            var indexStr = NSString(format: _imageNumFormat, i)
            //
            var fileName = _imageNameFormat + indexStr + ".jpg"
            
            let image = UIImage(named: fileName)
            if image == nil {
                println("画像がありません。")
            } else {
                _imageFileNames.append(fileName)
            }
        }
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
            changeImageWithFade(bgImage!)
        }
    }
    
    //
    func changeImageWithFade(image: UIImage) {
        UIView.transitionWithView(self.view, //_bgImageView,
            duration: 1.0,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: {
                self._charImageView.image = image
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
    
    func showMsgWindow() {
        delay(0.01, {
            self.showOrHideMsgWindow()
        })
        
        let text = _sampleTexts[_msgIndex]
        _fadeLabel.showTextWithFade(text)
        //_fadeLabel.showText(text)
        _aText = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        _aText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, _aText.length))
        _msgWindowLabel.attributedText = _aText
        
        _msgIndex++
        if _sampleTexts.count <= _msgIndex {
            _msgIndex = 0
        }
    }
    
    func hideMsgWindow() {
        showOrHideMsgWindow()
    }
    
    func showOrHideMsgWindow() {
        UIView.transitionWithView(self.view, //_bgImageView,
            duration: 0.3,
            options: UIViewAnimationOptions.TransitionCrossDissolve,
            animations: {
                self._msgWindowImageView.hidden = !self._msgWindowImageView.hidden
            },
            completion: {
                finished in
        })
    }

    
    //===========================================================
    // 画面遷移
    //===========================================================
    
    // セグエ
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == nil {
            return
        }
        
        let id = segue.identifier!
        var pref = NSUserDefaults.standardUserDefaults()
        
        if id == "ls" {
            var vc: SleepPrViewController = segue.destinationViewController as SleepPrViewController
            vc._imageType = "ls"
            vc._imageNumFormat = "%03d"
        } else if id == "pr" {
            var vc: SleepPrViewController = segue.destinationViewController as SleepPrViewController
            vc._imageType = "pr"
            vc._imageNumFormat = "%02d"
        } else {
            var vc: SleepPrViewController = segue.destinationViewController as SleepPrViewController
            vc._imageType = "sq"
            vc._imageNumFormat = "%02d"
        }
        
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
    
    // 1つのラベルを作成
    func makeFadeLabel(frame: CGRect, text: NSString, font: UIFont) -> FadeLabel {
        var label = FadeLabel()
        label.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, frame.height)
        label.text = text
        label.font = font
        label.textAlignment = NSTextAlignment.Left
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 4
        //label.sizeToFit()
        
        return label
    }
    
    //===========================================================
    // UI
    //===========================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendImgFileNamesToArray()
        println(_imageFileNames)
        
        _msgWindowImageView.hidden = true
        
        _fadeLabel = makeFadeLabel(CGRectMake(20, 70, 240, 100), text: "", font: UIFont(name: "HiraKakuProN-W6", size: 16)!)
        _fadeLabel.setWaitSecToShowNextChar(0.04)
        _msgWindowImageView.addSubview(_fadeLabel)
        var label = UILabel(frame: CGRectMake(20, 70, 240, 100))
        _aText = NSMutableAttributedString(string: "ラベル")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 40
        
        _aText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, _aText.length))
        
        label.font = _dummyLabel.font
        label.attributedText = _aText
        label.textColor = UIColor.blackColor()
        //label.outlineColor = UIColor.whiteColor()
        label.numberOfLines = 5
        _msgWindowLabel = label
        _msgWindowLabel.hidden = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        _dummyLabel.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        _fadeLabel.showTextWithFade("こんばんは。今日も一日、お疲れ様でした。")
        _msgWindowImageView.addSubview(_msgWindowLabel)
        showMsgWindow()
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
    
    // タッチ
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            var t: UITouch = touch as UITouch
            
            //println(t.view.tag)
            var loc = t.locationInView(self.view)
            println(loc)
            
            if loc.y < 140 {
                changeImage()
            } else {
                if _msgWindowImageView.hidden == true {
                    showMsgWindow()
                } else {
                    hideMsgWindow()
                }
            }
            
            
        }
    }
    
    
    
    //@IBOutlet weak var _slimeImageView: UIImageView!
    
    //@IBOutlet weak var _playerImageView: UIImageView!
    //var _animationView =
    /*
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
    }*/
    
}

