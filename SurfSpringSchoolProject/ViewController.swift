//
//  ViewController.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 4/15/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFeedViewController" {
            let dvc = segue.destination as! FeedViewController
            
        }
    }
    @IBAction func cameraButton(_ sender: UIButton) {

    }
    
    @IBAction func UploadButton(_ sender: UIButton) {
    }
    
    
//    @IBAction func FeedButton(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
//        feedViewController.modalPresentationStyle = .overFullScreen
//        present(feedViewController, animated: true)
//    }
    
    
    


}

