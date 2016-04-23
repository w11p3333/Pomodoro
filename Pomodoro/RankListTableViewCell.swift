//
//  RankListTableViewCell.swift
//  Pomodoro
//
//  Created by 卢良潇 on 16/4/2.
//  Copyright © 2016年 卢良潇. All rights reserved.
//

import UIKit


struct RankList {
    let userName: String
    let time:String
}

class RankListTableViewCell: UITableViewCell {

    @IBOutlet weak var RankLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
