//
//  AppDelegate.swift
//  Pomodoro
//
//  Created by 卢良潇 on 16/4/2.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

//数据库
let realm = try! Realm()
//数据库结果集
var scheduleDateBase : Results<Schedule>!
//全局配色
var bgColor = UIColor(red: 251/255, green: 78/255, blue: 82/255, alpha: 1.0)
let defaultBgColor = UIColor(red: 251/255, green: 78/255, blue: 82/255, alpha: 1.0)
let restbgColor = UIColor(red: 32/255, green: 142/255, blue: 115/255, alpha: 1.0)
//默认时间
let defaultWorkTime :Int = 25 * 60
//用户保存的
var workTime:Int = 0
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

       
        //判断是否第一次启动
        if  !NSUserDefaults.standardUserDefaults().boolForKey("firstLaunch")
        {
           NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstLaunch")
              let rgb = [CGFloat(251)/255, CGFloat(78)/255, CGFloat(82)/255]
            //保存用户信息
            NSUserDefaults.standardUserDefaults().setObject(rgb, forKey: "color")
            NSUserDefaults.standardUserDefaults().setValue(defaultWorkTime, forKey: "workTime")
            bgColor = defaultBgColor
            workTime = defaultWorkTime
      
        }
        else
        {
       
            //读取用户设置的颜色
            let rgb = NSUserDefaults.standardUserDefaults().objectForKey("color") as! [AnyObject]
            bgColor = rgb.count == 0 ? defaultBgColor : UIColor(red: rgb[0] as! CGFloat, green: rgb[1] as! CGFloat, blue: rgb[2] as! CGFloat, alpha: 0.9)
            //读取用户设置的时间
            workTime = NSUserDefaults.standardUserDefaults().valueForKey("workTime") as! Int
            print(workTime)
            
        }
       
        
        

        //设置后台播放
     let session = AVAudioSession.sharedInstance()
      try!  session.setCategory(AVAudioSessionCategoryPlayback)
      try!  session.setActive(true)
        //添加本地推送
        if #available(iOS 8.0, *) {
            let uns = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(uns)
        }

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
  
        

        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //删除通知
        application.cancelAllLocalNotifications()
        //让角标消失
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

