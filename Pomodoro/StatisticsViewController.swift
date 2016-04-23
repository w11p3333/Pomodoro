//
//  StatisticsViewController.swift
//  Pomodoro
//
//  Created by 卢良潇 on 16/4/13.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import Charts


class StatisticsViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    //饼状图数据
    var workDetail = [String]()
    var workTimeArray = [Double]()
    
    //柱状图数据
    var day = ["5","10","15","20","25","30"]
    var daytime = [0.0,0.0,0.0,0.0,0.0,0.0]
    
    var allTime:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = bgColor
        
        // Do any additional setup after loading the view.
        print("看看")
        loadFromDataBase()
        setbarChart(day, values: daytime)
        setpieChart(workDetail, values: workTimeArray)
    }

    //读取数据库
    func loadFromDataBase()
    {
      scheduleDateBase = realm.objects(Schedule)
        
        
        for i in 0..<scheduleDateBase.count
        {
          let detail = scheduleDateBase[i].workDetail
          let worktime = scheduleDateBase[i].workTime
          let daystr =  scheduleDateBase[i].createDay as NSString
          let day = Int(daystr.substringWithRange(NSMakeRange(8, 2)))
          
            allTime += worktime
            
           if day < 5
           {
             daytime[0] = Double(allTime)
           }
           else if day < 10 && day > 5
           {  daytime[1] = Double(allTime)
           }
           else if day < 15 && day > 10
           {  daytime[2] = Double(allTime)
           }
           else if day < 20 && day > 15
           {  daytime[3] = Double(allTime)
           }
           else if day < 25 && day > 20
           {  daytime[4] = Double(allTime)
           }
            else
           {  daytime[5] = Double(allTime)
            }
            
          let index = workDetail.indexOf(detail)
        if index != nil
        {
            workTimeArray[index!] = workTimeArray[index!] + Double(worktime)
            print(workTimeArray)
            print(workDetail)
            
        }
         
          else
           {
          workDetail.append(detail)
          workTimeArray.append(Double(worktime))
            }
        }
        
        
        
    }
    
    //设置柱形图
    func setbarChart(dataPoints: [String], values: [Double]) {
               //设置数据
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "单位/分钟")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartDataSet.barShadowColor = UIColor.whiteColor()
        //设置样式
        var colors: [UIColor] = []
        
        for _ in 0...12 {
            
            colors.append(UIColor.randomColor())
        }
        
        chartDataSet.colors = colors
        chartDataSet.valueColors = [UIColor.whiteColor()]
        
        
        barChartView.data = chartData
        barChartView.descriptionText = "本月统计"
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.backgroundColor = bgColor
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBounce)
        

        
    }
        
        
        
    //设置饼状图
    func setpieChart(dataPoints: [String], values: [Double]) {
    
    
        //设置数据
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "单位/分钟")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        let attribute: NSDictionary = NSDictionary(object: bgColor, forKey: NSForegroundColorAttributeName)
        pieChartView.centerAttributedText = NSAttributedString(string: "工作分布", attributes: attribute as! [String : AnyObject])
        pieChartView.descriptionText = "工作统计"
       
        
        //设置样式
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
           
            colors.append(UIColor.randomColor())
        }
        
        pieChartDataSet.colors = colors
           pieChartView.backgroundColor = bgColor
    }
    
    
    @IBAction func backClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
  }


