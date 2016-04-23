//
//  SettingViewController.swift
//  Pomodoro
//
//  Created by 卢良潇 on 16/4/2.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

let silentMode = "silentMode"
class SettingViewController: UIViewController {

    //默认不静音
    var didSilent:Bool = false
    
    @IBOutlet weak var voiceBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        voiceBtn.setTitle("静音", forState: UIControlState.Normal)
        voiceBtn.setTitle("音乐", forState: UIControlState.Selected)
        self.voiceBtn.selected = NSUserDefaults.standardUserDefaults().boolForKey(silentMode) ? true : false

        self.view.backgroundColor = bgColor
    }

  
    @IBAction func setVoiceClick(sender: AnyObject) {

        if didSilent  {
        didSilent = false
        voiceBtn.selected = true
        }
        else
        {
         didSilent = true
         voiceBtn.selected = false
        
        }
        
       NSUserDefaults.standardUserDefaults().setBool(didSilent, forKey: silentMode)
        
    }
    @IBAction func resetColor(sender: AnyObject) {
        
     
        let rgb = [CGFloat(251)/255, CGFloat(78)/255, CGFloat(82)/255]
        NSUserDefaults.standardUserDefaults().setObject(rgb, forKey: "color")
        bgColor = UIColor(red: 251/255, green: 78/255, blue: 82/255, alpha: 1.0)
        
    }

    @IBAction func backClick(sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainVc")
        vc?.modalTransitionStyle = .FlipHorizontal
        self.presentViewController(vc!, animated: true, completion: nil)
    }
    
}
