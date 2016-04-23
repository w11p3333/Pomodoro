//
//  Schedule.swift
//  Pomodoro
//
//  Created by 卢良潇 on 16/4/4.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import Foundation
import RealmSwift

class Schedule: Object {
    

    dynamic var createDay:String!
    dynamic var createTime:String!
    dynamic var workTime:Int = 0
    dynamic var workDetail:String!
    
}
