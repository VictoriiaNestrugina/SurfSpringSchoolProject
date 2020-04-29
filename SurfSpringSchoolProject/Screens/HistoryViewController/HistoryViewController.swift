//
//  StatisticsViewController.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 4/16/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import CoreData
import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateImage: UIImageView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateArrowImage: UIImageView!
    @IBOutlet weak var emptyStateGuideLabel: UILabel!
    
    var savedImages: [ClassifiedImage] = []
    
    //For search
    var filteredImages: [ClassifiedImage] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the source of data
        tableView.dataSource = self
        tableView.delegate = self
        
        //Setting up the search bar
        //Informs HistoryViewController class of changes in the search bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        //Attaching the search bar to navigation bar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Load Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = ClassifiedImage.fetchRequest() as NSFetchRequest<ClassifiedImage>
        do {
            savedImages = try context.fetch(fetchRequest)
        } catch let error {
            print("Couldn't load the data. Error \(error)")
        }
        
        //Hide the table if there is no data
        if savedImages.isEmpty {
            tableView.isHidden = true
        } else {
            emptyStateImage.isHidden = true
            emptyStateLabel.isHidden = true
            emptyStateArrowImage.isHidden = true
            emptyStateGuideLabel.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredImages = savedImages.filter { (image: ClassifiedImage) -> Bool in
            return image.info!.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredImages.count
        }
        
        return savedImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let classifiedImage: ClassifiedImage
        if isFiltering {
            classifiedImage = filteredImages[indexPath.row]
        } else {
            classifiedImage = savedImages[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath) as! HistoryTableViewCell
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
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension HistoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
}
