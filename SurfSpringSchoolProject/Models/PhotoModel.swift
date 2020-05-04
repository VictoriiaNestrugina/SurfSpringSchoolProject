//
//  PhotoModel.swift
//  SurfSpringSchoolProject
//
//  Created by Victoriia Nestrugina on 4/24/20.
//  Copyright © 2020 Victoriia Nestrugina. All rights reserved.
//

import Foundation

struct UrlsModels: Codable {
    let regular: String
}

struct PhotoModel: Codable {
    let id: String
    let description: String?
    let urls: UrlsModels
}

struct SearchResult: Codable {
    let total_pages: Int
    let results: [PhotoModel]?
}
