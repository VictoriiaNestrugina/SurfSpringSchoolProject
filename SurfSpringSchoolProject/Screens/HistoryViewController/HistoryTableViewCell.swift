//
//  HistoryTableViewCell.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 4/21/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var analyzedImage: UIImageView!
    @IBOutlet weak var imageDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 15
        analyzedImage.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .white
        if selected {
            cellView.backgroundColor = UIColor(red: 0.749, green: 0.854, blue: 0.949, alpha: 1)
        } else {
            cellView.backgroundColor = UIColor(red: 240/255, green: 242/255, blue: 250/255, alpha: 1)
        }
        
    }
}
