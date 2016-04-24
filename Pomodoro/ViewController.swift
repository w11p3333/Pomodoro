//
//  ViewController.swift
//  Pomodoro
//
//  Created by 卢良潇 on 16/4/2.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
import MediaPlayer

//时间状态
struct timeState {
    
    static let WORKING:Int  = 0
    static let REST:Int = 1
    static let STOP:Int = 2
}

class ViewController: UIViewController {

    @IBOutlet var bgView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var labelView: UIView!
    
    @IBOutlet weak var mainTimeLabel: UILabel!
    
    @IBOutlet weak var smallTimeLabel: UILabel!
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var restTimeLabel: UILabel!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var allDayLabel: UILabel!
    //
    var pickview = UIPickerView()
    //标准休息时间
    var standardRestTime:Int = 5 * 60
    //当前时间
    var currentTime:Int = 0
    //时间对象
    var timer:NSTimer!
    //音乐对象
    var player = AVAudioPlayer()

    
    //设置状态
    var timeCurrentState = timeState.STOP
    //是否播放
    var isplaying:Bool = false
    
   
    // MARK: UI设置
    
    
    //launchScreen淡入效果
   private func launchAnimation()
    {
        
        let vc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewControllerWithIdentifier("Launch")
        let launchview = vc.view
        let delegate = UIApplication.sharedApplication().delegate
        let mainWindow = delegate?.window
        mainWindow!!.addSubview(launchview)
        
        
        UIView.animateWithDuration(1, delay: 0.5, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
            launchview.alpha = 0.0
            launchview.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1.0)
        }) { (finished) in
            launchview.removeFromSuperview()
        }
        

        
    }
  
    static var once:dispatch_once_t = 0
    //动画
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        //只执行一次
        dispatch_once(&ViewController.once) {
            self.launchAnimation()
        }
        
        
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 10,
                                   options: .CurveEaseInOut,
                                   animations: { () -> Void in
                                    self.contentView.transform = CGAffineTransformIdentity
        }) { (bool:Bool) -> Void in
            self.view.userInteractionEnabled = true
        }
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //赋值当前时间
        currentTime = workTime
        
        restTimeLabel.hidden = true
        mainTimeLabel.text = formatTime(currentTime)
        setLabelText()
        //设置动画效果
        self.view.userInteractionEnabled = false
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -1000)
        
        //设置背景手势
        bgView.backgroundColor = bgColor
        bgView.userInteractionEnabled = true
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.BackgroundViewDidSwiped))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.BackgroundViewDidSwiped))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        bgView.addGestureRecognizer(rightSwipe)
        bgView.addGestureRecognizer(leftSwipe)
        //设置时间长按手势
        mainTimeLabel.userInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.mainTimeLabelDidLongPress))
            longPress.minimumPressDuration = 1.0
        mainTimeLabel.addGestureRecognizer(longPress)
        
        
   
    }
    
    //设置label显示
    func setLabelText()
    {
        scheduleDateBase = realm.objects(Schedule)
        todayLabel.text = "今天:\(realm.objects(Schedule).filter("createDay = '\(getNowTime().first!)'").count)"
        allDayLabel.text = "历史番茄数:\(scheduleDateBase.count)"
    }
    
    // MARK: 手势方法
    
    //设置滑动背景颜色 
    func BackgroundViewDidSwiped()
    {
    let r = UIColor.randomValue()
    let g = UIColor.randomValue()
    let b = UIColor.randomValue()
    bgColor = UIColor(red: r, green: g, blue: b, alpha: 0.9)
    let rgb = [r,g,b]
     NSUserDefaults.standardUserDefaults().setObject(rgb, forKey: "color")
    self.view.backgroundColor = bgColor
     self.view.layoutIfNeeded()
    }
    

    //长按时间显示pickview
    func mainTimeLabelDidLongPress()
    {
        //播放时不能选择

        if timeCurrentState == timeState.WORKING
        {
          return
        }
         mainTimeLabel.hidden = true
         startBtn.hidden = true
        /**
         *  确保pickview只被创建一次
         */
        
        if self.view.subviews.count == 10
        {
            
            let height: CGFloat = 216
        pickview.frame = CGRectMake(0, (UIScreen.mainScreen().bounds.height / 2 - height / 2), (UIScreen.mainScreen().bounds.width / 2), height)
        
        pickview.delegate = self
        pickview.dataSource = self
        self.view.addSubview(pickview)
        }
        else
        {
        pickview.hidden = false
        return
        }
       
    }
    
    
    
    // MARK: 点击方法
    @IBAction func startClick(sender: AnyObject) {
        
        
        if startBtn.selected
        {
            //停止按钮
            stopTime()
            stopMusic()
           
        }
        else
        {
            
        startBtn.selected = true
            //监听时间
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
            timeCurrentState = timeState.WORKING
            playMusic()
            //设置常亮
            UIApplication.sharedApplication().idleTimerDisabled = true
            UIScreen.mainScreen().brightness = 0.01
            
        }
 
    }
    
  
    @IBAction func statisticsClick(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("StatisticsNav")
        self.presentViewController(vc!, animated: true, completion: nil)
    }
    @IBAction func rankListClick(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RankListNav")
        self.presentViewController(vc!, animated: true, completion: nil)
    }
    @IBAction func settingClick(sender: AnyObject) {
        timeCurrentState = timeState.STOP
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SettingVc")
        vc?.modalTransitionStyle = .FlipHorizontal
        self.presentViewController(vc!, animated: true, completion: nil)
    }
    
    @IBAction func tipsClick(sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("Tips")
        self.definesPresentationContext = true
        vc?.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        vc?.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        self.presentViewController(vc!, animated: false, completion: nil)
    }
    
    // MARK: 时间方法
    
    //更新时间
    func updateTime()
    {
         var time:String
 
        switch timeCurrentState {
        case timeState.REST:
            //设置变色
            stopMusic()
            self.mainTimeLabel.textColor = UIColor.whiteColor()
             self.view.backgroundColor = restbgColor
            startBtn.hidden = true
            if currentTime == 0
            {
                currentTime = workTime
                timeCurrentState = timeState.WORKING
                startBtn.hidden = false
                playMusic()

                return
            }
            
            //进入休息时间
            restTimeLabel.hidden = false
            time = formatTime(currentTime)
            mainTimeLabel.text = time
            currentTime -= 1
            
        case timeState.WORKING:
            
            setLockedScreenInfo()
            self.mainTimeLabel.textColor = UIColor.whiteColor()
            self.view.backgroundColor = bgColor
            //判断是否走到0了
            if currentTime == 0
            {
            currentTime = standardRestTime
            timeCurrentState = timeState.REST
                //停止原来的
            stopMusic()
                //显示提示框
            showAlertController()
                //重新播放
            playMusic()
                //发送推送
            sendLocalNotificaiton()
        
            return
            }
            //小于三分钟变颜色
            if currentTime <= 60 * 3
            {
             self.mainTimeLabel.textColor = UIColor.orangeColor()
            }
            //进入工作倒计时
            restTimeLabel.hidden = true
            time = formatTime(currentTime)
            mainTimeLabel.text = time
            currentTime -= 1
        default:
            //停止
           stopMusic()
           stopTime()
            
        }
    }

    
    //停止时间
    func stopTime()
    {
        //放弃任务
        startBtn.selected = false
        self.timer.invalidate()
        //重置时间
        currentTime = workTime
        let time = formatTime(currentTime)
        mainTimeLabel.text = time
        //重置状态
        timeCurrentState = timeState.STOP
        //重置颜色
        mainTimeLabel.textColor = UIColor.whiteColor()
    }

    //格式化时间
    func formatTime(time:Int) -> String
    {
        let min = time / 60
        let second = time % 60
        let time = String(format: "%02d:%02d", arguments: [min,second])
        return time
    }
    
    //获取当前时间
    func getNowTime() -> [String]
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

    
    // MARK:alert
    
    //显示alert
    func showAlertController()
    {

        let alert = UIAlertController(title: "恭喜你完成了一个番茄！", message: "请输入完成的内容", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "添加", style: UIAlertActionStyle.Default) { (action) in
            
            
 
            self.writeToDateBase((alert.textFields?.first?.text)!)
            //移除通知
          NSNotificationCenter.defaultCenter().removeObserver(self)
            
        }
        
                //添加输入框
        alert.addTextFieldWithConfigurationHandler { (textfield) in
            
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.textFieldDidChahge(_:)), name: UITextFieldTextDidChangeNotification, object: textfield)
            
        }
        //将按钮设置为不可点
        okAction.enabled = false
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    
    
    //监听textfield
    func textFieldDidChahge(notification: NSNotification)
    {
        
        let alert = self.presentedViewController as? UIAlertController
        if alert != nil
        {
            let textfield = alert?.textFields?.first?.text
            let okAction = (alert?.actions.last)! as UIAlertAction
            //text长度大于0时设置为可点
            okAction.enabled = ((textfield! as NSString).length > 0)
        }
        
    }
    
    //写入数据库
    func writeToDateBase(workDetail:String)
    {
        let dbItem = Schedule()
        dbItem.workDetail = workDetail
        dbItem.createDay = self.getNowTime().first
        dbItem.createTime = self.getNowTime().last
        dbItem.workTime = workTime / 60
        try! realm.write({
            
            realm.add(dbItem)
            self.setLabelText()
            
        })

    }
    
    
    // MARK: 音乐方法
    
  //播放音乐
    func playMusic()
    {
       if NSUserDefaults.standardUserDefaults().boolForKey(silentMode)
        {
        
            return
        }
        
        if isplaying
        {
         
         return
        }
        
        
        let bgMusic = timeCurrentState == timeState.WORKING ? NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("乡村野外Feel", ofType: "mp3")!) : NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("叮", ofType: "mp3")!)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            try AVAudioSession.sharedInstance().setActive(true)

            try player = AVAudioPlayer(contentsOfURL: bgMusic)
            player.prepareToPlay()
            player.play()
            isplaying = true
            
            
        }
        catch let error as NSError {
            print(error)
        }
        
    
    }
  //停止音乐
    func stopMusic()
    {
        
        if isplaying
        {
        player.stop()
        isplaying = false
        }
    }
    
    
    
    
    
    //设置推送
    func sendLocalNotificaiton()
    {
        
        let localNotification = UILocalNotification()
        //通知具体内容
        localNotification.alertBody = "你已经完成了一个番茄钟啦"
        //app名称
        if #available(iOS 8.2, *) {
            localNotification.alertTitle = "Pomodoro"
        } else {
            // Fallback on earlier versions
        }
        //设置角标
        localNotification.applicationIconBadgeNumber = 1
        //设置滑动任务
        localNotification.alertAction = "输入任务内容"
        //立即发送
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)

        
        
       
    }
   

    
    //锁屏信息
    func setLockedScreenInfo()
    {

        
        //获取锁屏界面中心
    let playingInfoCenter = MPNowPlayingInfoCenter.defaultCenter()
        //设置展示的信息
        let artwork = MPMediaItemArtwork(image: UIImage(named: "tomato-icon")!)
        let info = [MPMediaItemPropertyAlbumTitle:"Pomodoro",MPMediaItemPropertyArtwork:artwork,MPMediaItemPropertyPlaybackDuration:currentTime]

    
    playingInfoCenter.nowPlayingInfo = info
        //让应用可以接受远程事件
    UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
    }
    
    
    //锁屏界面的操作
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        
        
        if event?.subtype == UIEventSubtype.RemoteControlStop
        {
            
            //停止按钮
            stopTime()
            stopMusic()
               }
        if event?.subtype == UIEventSubtype.RemoteControlPlay
        {
            startBtn.selected = true
            //监听时间
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
            timeCurrentState = timeState.WORKING
            playMusic()
        }
        
    }
   
}



//pickview数据源
  var timeData = ["01","05","10","15","20","25","30","35","40","45"]

  // MARK:  pickerview
extension ViewController:UIPickerViewDelegate, UIPickerViewDataSource
{

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeData.count
    }
  

    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //保存时间
        let time = Int(timeData[row])! * 60
        //更新时间信息
        workTime = time
        currentTime = time
        NSUserDefaults.standardUserDefaults().setValue(time, forKey: "workTime")
        mainTimeLabel.text = formatTime(time)
        pickview.hidden = true
        //重新显示时间
        mainTimeLabel.hidden = false
        startBtn.hidden = false
    }
    
   
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel()
        label.frame = CGRectMake(0, 0, (self.mainTimeLabel.bounds.width / 2) + 90, self.mainTimeLabel.bounds.height)
        label.textColor = UIColor.whiteColor()
        label.text = timeData[row]
        label.font = UIFont.systemFontOfSize(90)
        label.textAlignment = NSTextAlignment.Center
        return label
    }
    
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.mainTimeLabel.bounds.height
    }
 
    
    
}

 