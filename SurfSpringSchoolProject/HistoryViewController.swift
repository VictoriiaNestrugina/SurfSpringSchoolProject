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
    var newImage: ClassifiedImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = newImage {
            savedImages.append(image)
        }
        
        //We are setting the source of data
        tableView.dataSource = self
        tableView.delegate = self
        
        //Used for UITableViewController
        //navigationItem.rightBarButtonItem = editButtonItem
        
        //Used to point that we can reuse a cell, useless if you use Interface builder
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
        
        //Initialize savedImages - for debug purposes only
        //savedImages = fillHistoryArray()
        
        if savedImages.isEmpty {
            tableView.isHidden = true
        } else {
            emptyStateImage.isHidden = true
            emptyStateLabel.isHidden = true
            emptyStateImage2.isHidden = true
            emptyStateLabel2.isHidden = true
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disappiaring")
    }
    
    //For debug purposes only
    func fillHistoryArray() -> [ClassifiedImage] {
        var tempClassifiedImageArray: [ClassifiedImage] = []
        let classifiedImage = ClassifiedImage(image: UIImage(named: "images")!, description: "Description")
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
        cell.imageDescription.text = classifiedImage.info
        return cell
    }
    
    //Editing mode - deleting cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedImages.remove(at: indexPath.row)
            //Deleting a row - not a very good style:
            //tableView.reloadData()
            //Best solution, comes with animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
