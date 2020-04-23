//
//  StatisticsViewController.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 4/16/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateImage: UIImageView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateImage2: UIImageView!
    @IBOutlet weak var emptyStateLabel2: UILabel!
    
    var savedImages: [ClassifiedImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //We are setting the source of data
        tableView.dataSource = self
        tableView.delegate = self
        //Used to point that we can reuse a cell, useless if you use Interface builder
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
        // Do any additional setup after loading the view.
        
        //Добавить инициализацию savedImages
        savedImages = fillHistoryArray()
        if savedImages.isEmpty {
            tableView.isHidden = true
        } else {
            emptyStateImage.isHidden = true
            emptyStateLabel.isHidden = true
            emptyStateImage2.isHidden = true
            emptyStateLabel2.isHidden = true
        }
        
        
    }
    
    func fillHistoryArray() -> [ClassifiedImage] {
        var tempClassifiedImageArray: [ClassifiedImage] = []
        var classifiedImage = ClassifiedImage(image: UIImage(named: "images")!, description: "Description")
        for _ in 0...9 {
            tempClassifiedImageArray.append(classifiedImage)
        }
        return tempClassifiedImageArray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let classifiedImage = savedImages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath) as! HistoryTableViewCell
        cell.cellView.layer.cornerRadius = 15
        cell.analyzedImage.layer.cornerRadius = 15
        cell.analyzedImage.image = classifiedImage.image
        cell.imageDescription.text = classifiedImage.description
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
