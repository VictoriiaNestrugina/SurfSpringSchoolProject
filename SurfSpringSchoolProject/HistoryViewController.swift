//
//  StatisticsViewController.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 4/16/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import UIKit
import CoreData

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = ClassifiedImage.fetchRequest() as NSFetchRequest<ClassifiedImage>
        do {
            savedImages = try context.fetch(fetchRequest)
        } catch let error {
            print("Couldn't load the data. Error \(error)")
        }
        
        if savedImages.isEmpty {
            tableView.isHidden = true
        } else {
            emptyStateImage.isHidden = true
            emptyStateLabel.isHidden = true
            emptyStateImage2.isHidden = true
            emptyStateLabel2.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let classifiedImage = savedImages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath) as! HistoryTableViewCell
        cell.cellView.layer.cornerRadius = 15
        cell.analyzedImage.layer.cornerRadius = 15
        cell.analyzedImage.image = UIImage(data: classifiedImage.image!)
        cell.imageDescription.text = classifiedImage.info
        return cell
    }
    
    //Editing mode - deleting cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //Delete from Core Data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let imageToDelete = savedImages[indexPath.row]
            context.delete(imageToDelete)
            savedImages.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch let error {
                print("Couldn't save the context. Error \(error)")
            }
            
            //Deleting a row - not a very good style:
            //tableView.reloadData()
            //Best solution, comes with animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
