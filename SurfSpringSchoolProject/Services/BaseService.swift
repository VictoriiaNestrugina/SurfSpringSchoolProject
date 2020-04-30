//
//  BaseService.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 4/23/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import Foundation

enum NetworkConstants {
    static let accessKey = "tdyEZYQXoRNdAOJUW1hzrltncM9_IN_jhDW74WTW084"
    static let newURL = "/photos?client_id="
    static let randomURL = "/photos/random?count=1&client_id="
    static let baseURL = "https://api.unsplash.com"
}

enum ServerError: Error {
    case noDataProvided
    case failedToDecode
}

class BaseService {
    
    func loadPhotos(isRandom: Bool, onComplete: @escaping ([PhotoModel]) -> Void, onError: @escaping (Error) -> Void) {
        let urlString: String
        
        if isRandom {
            urlString = NetworkConstants.baseURL + NetworkConstants.randomURL + NetworkConstants.accessKey
        } else {
            urlString = NetworkConstants.baseURL + NetworkConstants.newURL + NetworkConstants.accessKey
        }
        
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            dump(data)
            dump(response)
            dump(error)
            if let error = error {
                onError(error)
                return
            }
            
            guard let data = data else {
                onError(ServerError.noDataProvided) 
                return
            }
            
            guard let photos = try? JSONDecoder().decode([PhotoModel].self, from: data) else {
                print("Could not decode")
                onError(ServerError.failedToDecode)
                return
            }
            
            DispatchQueue.main.async {
                onComplete(photos)
            }
        }
        //Perform the task
        task.resume()
    }

}
