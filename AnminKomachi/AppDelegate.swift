//
//  AppDelegate.swift
//  AnminKomachi
//
//  Created by hideki on 2014/12/24.
//  Copyright (c) 2014年 Tsubaki. All rights reserved.
//

import UIKit
import AVFoundation
//import Realm

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var _player = SoundPlayer()
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        println(NSStringFromClass(AppDelegate))
        println("起動中 willFinishLaunchingWithOptions")
        // 起動音を鳴らす
        //_player.playSE("koron")
        
        var pref = NSUserDefaults.standardUserDefaults()
        pref.setObject("portrait", forKey: "orientation")
        // 画面の縦幅を記録
        let height = Int(UIScreen.mainScreen().bounds.size.height)
        pref.setInteger(height, forKey: "screenHeight")
        let width = Int(UIScreen.mainScreen().bounds.size.width)
        pref.setInteger(width, forKey: "screenWidth")
        
        pref.synchronize()
        
        //println(RLMRealm.defaultRealmPath())
        
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        println("起動中 didFinishLaunchingWithOptions")
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // 画面の回転
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        
        //println(self.window?.rootViewController?.presentedViewController)
        
    
        var or = NSUserDefaults.standardUserDefaults().stringForKey("orientation")

        if or != nil {
            //println(or)
            if or! == "portrait" {
                println("縦向きにします")
                return Int(UIInterfaceOrientationMask.Portrait.rawValue);
            } else if or! == "landscape" {
                println("横向きにします")
                return Int(UIInterfaceOrientationMask.LandscapeRight.rawValue);
            }
        }
                
        if self.window?.rootViewController?.presentedViewController? is SleepLsViewController {
            //println("横向きにします")
            return Int(UIInterfaceOrientationMask.LandscapeRight.rawValue);
        } else {
            //println("縦向きにします")
            return Int(UIInterfaceOrientationMask.Portrait.rawValue);
        }
    }
    
    /*
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        let rc = event.subtype
        //let p = self.player.player
        println("received remote control \(rc.rawValue)")
    }*/
}


