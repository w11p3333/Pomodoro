//
//  RankListTableViewController.swift
//  Pomodoro
//
//  Created by 卢良潇 on 16/4/2.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit

class RankListTableViewController: UITableViewController {

    
    
    var data = [ RankList(userName:"Lu Liangxiao",time: "300"),
                 RankList(userName:"Daniel Hooper",time: "200"),
                 RankList(userName:"David Beckham",time: "100"),
                 RankList(userName:"Bruce Fan",time: "90"),
                 RankList(userName:"bruce",time: "80"),
                 RankList(userName:"davidbeckham",time: "70"),
                 RankList(userName:"allen",time: "60")
               ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
  
        self.navigationController?.navigationBar.barTintColor = bgColor
        
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
        
        tableView.rowHeight = 85
        tableView.backgroundColor = bgColor
        tableView.tableFooterView = UIView()
           }
    
    
    @IBAction func backClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareClick(sender: AnyObject) {
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        animationTable()
        
    }
    
    //动画效果
    func animationTable() {
        
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }

    

   

    // MARK: - Table view data source



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RankListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let cellData = data[indexPath.row]
        cell.profileImageView.image = UIImage(named: "myProfileImage")
        cell.profileImageView.clipsToBounds = true
        cell.profileImageView.layer.cornerRadius = (cell.profileImageView.frame.width / 2)
        cell.RankLabel.text = String(indexPath.row + 1)
        cell.RankLabel.textColor = bgColor
        cell.nameLabel.text = cellData.userName
        cell.nameLabel.textColor = bgColor
        cell.timeLabel.text = cellData.time + "分钟"
        cell.timeLabel.textColor = bgColor

        return cell
    }
    




}
