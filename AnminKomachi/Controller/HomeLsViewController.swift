//
//  HomeLsViewController.swift
//  AnminKomachi
//
//  Created by hideki on 2015/01/06.
//  Copyright (c) 2015年 Tsubaki. All rights reserved.
//

import Foundation
import UIKit
//import SQLite

class HomeLsViewController: UIViewController {

    @IBOutlet weak var _bgImageView: UIImageView!
    
    @IBOutlet weak var _textLabel: FadeLabel!
    
    var _screenHeight = 0
    
    //
    let _imageNameFormat = "cover_ls"
    //
    let _imageNumFormat = "%02d"
    
    //
    var _imageFileNames = [String]()
    //
    var _imageIndex = 0
    
    var _msgIndex = 0
    
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
    
    //
    func showRandomImage() {
        _imageIndex = rand(_imageFileNames.count)
        changeImage()
    }
    
    // 画像の変更
    func changeImage() {
        _imageIndex++
        
        if _imageFileNames.count <= _imageIndex {
            _imageIndex = 0
        } else {
            let fileName = _imageFileNames[_imageIndex]
            let image  = UIImage(named: fileName)
            let aspect = calcImgAspect(image)
            
            // 画像の横幅 画面の縦幅と同じ
            let imageWidth = CGFloat(_screenHeight)
            // 画像の縦幅
            let imageHeight = imageWidth / aspect
            
            _bgImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight)
            println("imageViewのサイズ: \(_bgImageView.frame)")
            changeImageWithFade(image!)
        }
    }
    /*
    
    // 画像の変更
    func changeImage() {
        _imageIndex++
        //
        var indexStr = NSString(format: _imageNumFormat, _imageIndex)
        //
        var fileName = "cover_\(_imageType)" + indexStr + ".jpg"
        println(fileName)
        
        let bgImage = UIImage(named: fileName)
        
        if bgImage == nil {
            println("画像がありません。")
            _imageIndex = 0
            changeImage()
        } else {
            let aspect = calcImgAspect(bgImage)
            
            // 画像の横幅 画面の縦幅と同じ
            let imageWidth = CGFloat(_screenHeight)
            // 画像の縦幅
            let imageHeight = imageWidth / aspect
            _bgImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight)
            println("imageViewのサイズ: \(_bgImageView.frame)")
            changeImageWithFade(bgImage!)
        }
    }*/
    
    // クロスフェードで画像を変更
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
    
    func makeAttributedString(text: String) -> NSMutableAttributedString {
        // 属性付き文字
        var aString = NSMutableAttributedString(string: text)
        // 文字間の調節
        aString.addAttribute(NSKernAttributeName, value: 1.7, range: NSMakeRange(0, aString.length))
        // 行間の調節
        let pStyle = NSMutableParagraphStyle()
        pStyle.lineSpacing = 12
        aString.addAttribute(NSParagraphStyleAttributeName, value: pStyle, range: NSMakeRange(0, aString.length))
        
        return aString
    }

    
    //===========================================================
    // タッチ
    //===========================================================
    
    // タッチ
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        /*
        println(self.view.frame)
        println(self.view.bounds)
        println(UIScreen.mainScreen().bounds.size)
        */
        for touch: AnyObject in touches {
            var t: UITouch = touch as UITouch
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
    // 画面遷移
    //===========================================================
    
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
        //NSUserDefaults.standardUserDefaults().setObject("portrait", forKey: "orientation")
        //NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //===========================================================
    // UI
    //===========================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // デバイスの縦幅を取得
        var pref = NSUserDefaults.standardUserDefaults()
        _screenHeight = pref.integerForKey("screenHeight")
        
        appendImgFileNamesToArray()
        
        showRandomImage()
        
        // 属性付き文字
        var aString = makeAttributedString("こんばんは。今日も一日お疲れ様です。")
        _textLabel.outlineColor = UIColor.darkGrayColor()
        _textLabel.textColor = UIColor.whiteColor()
        _textLabel.outlineSize = 2.5
        //_textLabel.outlineSize = 1.5
        _textLabel.font = UIFont(name: "azuki_font", size: 18)
        _textLabel.font = UIFont(name: ".HiraKakuInterface-W6", size: 18)
        _textLabel.attributedText = aString
        //　グローエフェクト
        _textLabel.layer.shadowColor   = UIColor.blackColor().CGColor
        _textLabel.layer.shadowRadius  = 3.0
        _textLabel.layer.shadowOpacity = 0.3
        _textLabel.layer.shadowOffset  = CGSizeZero
        _textLabel.layer.masksToBounds = false
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func viewWillAppear(animated: Bool) {
        //println(UIScreen.mainScreen().bounds.size)
        changeImage()
    }
    
    // 回転の許可
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // ステータスバーを非表示
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

