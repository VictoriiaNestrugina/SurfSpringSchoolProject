//
//  UIImageView.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 5/1/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(by imageURL: String) {
        let url = URL(string: imageURL)!
        //do loading from the given URL
        //let data = try! Data(contentsOf: url)
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        if let imageData = cache.cachedResponse(for: request)?.data {
            self.image = UIImage(data: imageData)
        } else {
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                DispatchQueue.main.async {
                    guard let data = data, let response = response else {
                        return
                    }
                    let cacheResponse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cacheResponse, for: request)
                    self.image = UIImage(data: data)
                }
            }.resume()
        }
        
    }
}
