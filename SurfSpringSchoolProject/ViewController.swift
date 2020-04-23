//
//  ViewController.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 4/15/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var image: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cameraButton(_ sender: UIButton) {
        presentPhotoPicker(sourceType: .camera)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    
    @IBAction func uploadButton(_ sender: UIButton) {
        presentPhotoPicker(sourceType: .photoLibrary)
    }
    
    
    
    func classify(identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as! FeedViewController
        feedViewController.modalPresentationStyle = .overFullScreen
        present(feedViewController, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToFeedViewController":
            let dvc = segue.destination as! FeedViewController
            
        default:
            break
        }
        
    }


}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Handling Image Picker Selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let classificatorViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ImageClassificationViewController
        classificatorViewController.image = image
        //performSegue(withIdentifier: "goToClassificator", sender: nil)
        present(classificatorViewController, animated: true)
        
        
//        imageView.image = image
//        updateClassifications(for: image)
    }

}
