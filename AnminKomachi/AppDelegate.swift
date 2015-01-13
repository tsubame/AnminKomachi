//
//  AppDelegate.swift
//  AnminKomachi
//
//  Created by hideki on 2014/12/24.
//  Copyright (c) 2014年 Tsubaki. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //NSNotificationCenter.defaultCenter().removeObserver(self)

        //UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        //var audioSession = AVAudioSession.sharedInstance()
        //audioSession.setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.MixWithOthers, error: nil)
        //audioSession.setCategory(AVAudioSessionCategoryPlayback, withOptions: AVAudioSessionCategoryOptions.DuckOthers, error: nil)
        //audioSession.setActive(true, error: nil)
        
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
        
        println(self.window?.rootViewController?.presentedViewController)
        
    
        var or = NSUserDefaults.standardUserDefaults().stringForKey("orientation")

        if or != nil {
            println(or)
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


