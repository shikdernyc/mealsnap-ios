//
//  APIResponse.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/27/21.
//

import Foundation

struct GalleryImageResponse: Decodable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    let alreadyLiked: Bool
    let likeCount: Int
}

struct FetchGalleryImageForUserResponse: Decodable {
    let result: [GalleryImageResponse]
    let page: MealSnapAPIPageResponse?
}
