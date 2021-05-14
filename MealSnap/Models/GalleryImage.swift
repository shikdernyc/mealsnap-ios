//
//  GalleryImage.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/6/21.
//

import Foundation

class GalleryImage: Decodable {
    let id: String
    private let ownerId: String
    let title: String
    let description: String
    let imageUrl: String
    var alreadyLiked: Bool
    var likeCount: Int
    
    init(imageResponse: GalleryImageResponse, ownerId: String) {
        self.id = imageResponse.id
        self.title = imageResponse.title
        self.description = imageResponse.description
        self.imageUrl = imageResponse.imageUrl
        self.alreadyLiked = imageResponse.alreadyLiked
        self.likeCount = imageResponse.likeCount
        self.ownerId = ownerId
    }
    
    static func from(apiImage: GalleryImageResponse, ownerId: String ) -> GalleryImage {
        return GalleryImage(imageResponse: apiImage, ownerId: ownerId)
    }
    
    func like(callback: @escaping((Result<Bool, Error>) -> Void)) {
        print("selected like")
        if alreadyLiked {
            print("Already liked")
            return
        }
        let route = "/user/\(ownerId)/photo/\(id)/interaction/like"
        let body: [String:String] = [:]
        MealSnapAPI.PostRequest(route: route, body: body){result in
            switch(result){
            case .success:
                self.alreadyLiked = true
                self.likeCount += 1
                callback(.success(true))
                return
            case .failure(let error):
                callback(.failure(error))
                print(error)
            }
        }
    }
}
