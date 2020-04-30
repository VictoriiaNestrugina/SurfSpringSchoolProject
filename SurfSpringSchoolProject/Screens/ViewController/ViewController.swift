//
//  ViewController.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 4/15/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageToClassify: UIImage?
    var photos = [PhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let service = BaseService()
        service.loadPhotos(isRandom: true, onComplete: { [weak self] (photos) in
            self?.photos = photos
        }) { (error) in
            print(error.localizedDescription)
        }
        print(self.photos.count)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    @IBAction func cameraButton(_ sender: UIButton) {
        presentPhotoPicker(sourceType: .camera)
    }
    
    @IBAction func uploadButton(_ sender: UIButton) {
        presentPhotoPicker(sourceType: .photoLibrary)
    }
    

    
    @IBAction func downloadRandomFromUnsplash(_ sender: UIButton) {
        let model = photos[0]
        let url = URL(string: model.urls.regular)!
        //do loading from the given URL
        let data = try! Data(contentsOf: url)
        self.imageToClassify = UIImage(data: data)
        classify()
    }
    
    func classify() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let classificatorViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ImageClassificationViewController
        classificatorViewController.image = self.imageToClassify
        present(classificatorViewController, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Handling Image Picker Selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        self.imageToClassify = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        classify()
    }
}

//extension UIImageView {
//    func loadImage(by imageURL: String) {
//        let url = URL(string: imageURL)!
//        //do loading from the given URL
//        let data = try! Data(contentsOf: url)
//        self.image = UIImage(data: data)
//    }
//}
