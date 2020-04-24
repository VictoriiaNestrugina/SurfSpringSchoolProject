//
//  ImageClassificationViewController.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 4/17/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import UIKit
import CoreData
import CoreML
import Vision
import ImageIO


class ImageClassificationViewController: UIViewController {
    
    var image: UIImage?
    var info: String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var classificationLabel: UILabel!
    
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        classificationLabel.layer.masksToBounds = true
        classificationLabel.layer.cornerRadius = 10
        image = image ?? UIImage(named: "somethingWentWrong")!
        imageView.image = image
        updateClassifications(for: image!)
        
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MobileNet().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    //Performs Requests
    func updateClassifications(for image: UIImage) {
        classificationLabel.text = "Classifying..."
        
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                //image processing errors
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    //Updates the UI with the results of the classification.
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` is `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                self.classificationLabel.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(2)
                let descriptions = topClassifications.map { classification in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
                self.info = descriptions.joined(separator: "\n")
                self.saveClassifiedImage()
            }
        }
    }
    
    
    func saveClassifiedImage() {
        //Work with Core Date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newImage = ClassifiedImage(context: context)
        newImage.info = info!
        newImage.image = image?.pngData()
        newImage.imageId = UUID().uuidString
        
        //Error check. Must be in a do statement.
        do {
            try context.save()
        } catch let error {
            print("Error while saving an image. Error code \(error).")
        }
        
    }
}
