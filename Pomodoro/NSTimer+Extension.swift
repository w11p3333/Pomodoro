
//
//  NSTimer+Extension.swift
//  Pomodoro
//
//  Created by 卢良潇 on 16/5/2.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

extension NSTimer
{

    
    //格式化时间
  class  func formatTime(time:Int) -> String
    {
        let min = time / 60
        let second = time % 60
        let time = String(format: "%02d:%02d", arguments: [min,second])
        return time
    }
    
    //获取当前时间
  class  func getNowTime() -> [String]
    {
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let nowTime = timeFormatter.stringFromDate(date) as String
        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "yyy-MM-dd"
        let dayTime = dayFormatter.stringFromDate(date) as String
        return [dayTime,nowTime]
        
    }
    
    

}