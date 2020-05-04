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
    static let baseURL = "https://api.unsplash.com"
    static let randomURL = "/photos/random?count=1&client_id="
    static let newURL = "/photos?client_id="
    static let searchURL = "/search/photos?page="//1&query="
}

enum ServerError: Error {
    case noDataProvided
    case failedToDecode
}

class BaseService {
    
    func loadRandomPhotos(onComplete: @escaping ([PhotoModel]) -> Void, onError: @escaping (Error) -> Void) {
        let urlString: String = NetworkConstants.baseURL + NetworkConstants.randomURL + NetworkConstants.accessKey
        
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
    
    func loadSearchedPhotos(query: String, pageNumber: Int, onComplete: @escaping (SearchResult) -> Void,
                            onError: @escaping (Error) -> Void) {
        let modifiedQuery = modifyQuery(query: query)
        let urlString: String = NetworkConstants.baseURL + NetworkConstants.searchURL + String(pageNumber)
            + "&query=" + modifiedQuery + "&client_id=" + NetworkConstants.accessKey
        let url = URL(string: urlString)!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            
            guard let data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            
            guard let photos = try? JSONDecoder().decode(SearchResult.self, from: data) else {
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
    
    func modifyQuery(query: String) -> String {
        let forbiddenLiterals = ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "\\", "|", "/", " ",
                                ".", "_", "~", ":", "?", "#", "[", "]", "'", "*", "+", ",", ";", "=", "<", ">"]
        var modifiedQuery = query
        
        for literal in forbiddenLiterals {
            modifiedQuery = modifiedQuery.replacingOccurrences(of: literal, with: "+", options: .literal, range: nil)
        }
        
        return modifiedQuery
    }
}
