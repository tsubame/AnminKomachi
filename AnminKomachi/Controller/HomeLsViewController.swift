//
//  HomeLsViewController.swift
//  AnminKomachi
//
//  Created by hideki on 2015/01/06.
//  Copyright (c) 2015年 Tsubaki. All rights reserved.
//

import Foundation
import UIKit

class HomeLsViewController: UIViewController {

    @IBOutlet weak var _bgImageView: UIImageView!
    
    // ls or pr
    var _imageType = "ls"
    //
    var _imageNumFormat = "%03d"
    //
    var _imageIndex = 0
    //
    var _orientation = "landscape"
    
    /*
    // 画像のサイズ調整
    func bgImageAdjust() {
        let bgimage = UIImage(named: "cover_ls_001.jpg")
        let imageSize = bgimage?.size
        let width = imageSize?.width
        let height = imageSize?.height
        let aspect = height! / width!
        // 画像の横幅 画面の横幅と同じ
        let imageWidth  = UIScreen.mainScreen().bounds.size.height
        // 画像の縦幅
        let imageHeight = imageWidth * aspect
        _bgImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight)
        _bgImageView.image = bgimage
        _bgImageView.contentMode = UIViewContentMode.ScaleAspectFill
        println(_bgImageView)
    
        //_bgImageView.hidden = false
        
        println(_bgImageView.frame)
        println(self.view.frame)
    }
    
    func bgImageAdd() {
        let bgimage = UIImage(named: "cover_ls_001.jpg")
        let imageSize = bgimage?.size
        let width  = imageSize?.width
        let height = imageSize?.height
        let aspect = height! / width!
        // 画像の横幅 画面の横幅と同じ
        let imageWidth  = self.view.frame.height
        // 画像の縦幅
        let imageHeight = imageWidth * aspect
        var bgImageView = makeImageView(CGRectMake(0, 0, imageWidth, imageHeight), bgimage!) //.frame = CGRectMake(0, 0, imageWidth, imageHeight)
        bgImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(bgImageView)
    }*/
    
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
            let imageHeight = imageWidth / aspect
            _bgImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight)
            println("imageViewのサイズ: \(_bgImageView.frame)")
            //_bgImageView.image = bgImage
            //_bgImageView.contentMode = UIViewContentMode.ScaleAspectFill
            changeImageWithFade(bgImage!)
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
    // タッチ
    //===========================================================
    
    // タッチ
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        println(self.view.frame)
        println(self.view.bounds)
        println(UIScreen.mainScreen().bounds.size)
        
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
        //println(UIScreen.mainScreen().bounds.size)
    }
    
    override func viewDidAppear(animated: Bool) {
        //bgImageAdjust()
        //bgImageAdd()
        //blackoutClear()
    }
    
    override func viewWillAppear(animated: Bool) {
        println(UIScreen.mainScreen().bounds.size)
        //bgImageAdjust()
        //_bgBlackOut = UIView(frame: CGRectMake(0, 0, self.view.frame.height, self.view.frame.width))
        //_bgBlackOut.backgroundColor = UIColor.blackColor()
        //self.view.addSubview(_bgBlackOut)
    }
    
    // 回転の許可
    override func shouldAutorotate() -> Bool {
        return false
    }
}

