//
//  UnsplashTableViewController.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 5/2/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import UIKit

class UnsplashTableViewController: UITableViewController {

    @IBOutlet weak var noConnectionImage: UIImageView!
    @IBOutlet weak var noConnectionLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var noResultImage: UIImageView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    var randomPhoto: PhotoModel?
    var imageToClassify: UIImage?
    var searchResult: SearchResult?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noConnectionImage.isHidden = true
        noConnectionLabel.isHidden = true
        refreshButton.isHidden = true
        
        noResultImage.isHidden = true
        noResultLabel.isHidden = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        //Attaching the search bar to navigation bar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        loadData()
    }
 
    func loadData() {
        let service = BaseService()
        
        service.loadRandomPhotos(onComplete: { [weak self]  (photos) in
            self?.randomPhoto = photos[0]
            self?.tableView.reloadData()
        }) { (error) in
            self.noConnectionLabel.isHidden = false
            self.noConnectionImage.isHidden = false
            self.refreshButton.isHidden = false
            
            print(error.localizedDescription)
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshActionButton(_ sender: UIButton) {
        loadData();
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return searchResult?.results?.count ?? 0
        default:
            break
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Use a random image"
        case 1:
            return "Search results"
        default:
            break
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "newImageCell", for: indexPath) as! NewTableViewCell
            if let randomPhoto = self.randomPhoto {
                cell.newImage.loadImage(by: randomPhoto.urls.regular)
                cell.contentMode = .scaleAspectFill
            } else {
                cell.newImage.image = UIImage(systemName: ".photo")
                cell.contentMode = .scaleAspectFit
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "newImageCell", for: indexPath) as! NewTableViewCell
            let model = (searchResult?.results?[indexPath.row])!
            cell.newImage.loadImage(by: model.urls.regular)
            return cell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "newImageCell", for: indexPath) as! NewTableViewCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let photoSourcePicker = UIAlertController()
        let chooseThisImage = UIAlertAction(title: "Choose this image", style: .default) { [unowned self] _ in
            self.imageToClassify = (tableView.cellForRow(at: indexPath) as! NewTableViewCell).newImage.image
            print("the image under index path \(indexPath.row) was chosen")
            self.classify()
        }
        
        photoSourcePicker.addAction(chooseThisImage)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(photoSourcePicker, animated: true)
    }
    
    func classify() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let classificatorViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ImageClassificationViewController
        classificatorViewController.image = self.imageToClassify
        present(classificatorViewController, animated: true)
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String) {
        let service = BaseService()
        service.loadSearchedPhotos(query: searchText.lowercased(), pageNumber: 1, onComplete: { [weak self]  (searchResult) in
            self?.searchResult = searchResult
            if self?.searchResult?.results?.count == 0 && searchText.lowercased() != "" {
                self?.noResultImage.isHidden = false
                self?.noResultLabel.isHidden = false
            } else {
                self?.noResultImage.isHidden = true
                self?.noResultLabel.isHidden = true
            }
            self?.tableView.reloadData()
        }) { (error) in
            self.noConnectionLabel.isHidden = false
            self.noConnectionImage.isHidden = false
            self.refreshButton.isHidden = false

            print(error.localizedDescription)
        }
    }
}

extension UnsplashTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
