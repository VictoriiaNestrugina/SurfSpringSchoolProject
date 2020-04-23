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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
