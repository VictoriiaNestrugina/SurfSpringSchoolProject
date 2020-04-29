//
//  FeedViewController.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 4/19/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate  {
    
    @IBOutlet weak var sectionCollectionView: UICollectionView!
    @IBOutlet weak var newImagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionCollectionView.dataSource = self
        sectionCollectionView.delegate = self
        
        newImagesTableView.dataSource = self
        newImagesTableView.delegate = self
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newImageCell", for: indexPath) as! NewTableViewCell
        
        return cell
    }
}

extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CategoryViewCell
        cell.layer.cornerRadius = 15
        return cell
    }
}
