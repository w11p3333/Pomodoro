//
//  UIColor+Extension.swift
//  LLXWaterFlow
//
//  Created by 卢良潇 on 16/3/29.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
extension UIColor
{

    /// 随机生成色
    class func randomColor() -> UIColor
    {
        return UIColor(red: randomValue(), green: randomValue(), blue: randomValue(), alpha: 0.9)
    }
    
    /**
     随机生成值
     */
     class func randomValue() -> CGFloat {
        return CGFloat(arc4random_uniform(256)) / 255
    }


}
