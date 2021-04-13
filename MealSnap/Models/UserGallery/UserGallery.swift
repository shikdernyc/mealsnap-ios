//
//  Post.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/8/21.
//

import Foundation

struct GalleryImage: Decodable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
}

enum UserGalleryError : Error {
    case APIError(message: String)
}

struct UserGallery {
    static func AddImage(
        title: String,
        description: String,
        imageData: Data,
        completionHandler: @escaping (Result<GalleryImage, UserGalleryError>) -> Void) {
        let requestData = [
            "title": title,
            "description": description,
            "encodedImage": imageData.base64EncodedString()
        ]
        // TODO: Call the appropriate route
        MealSnapAPI.PostRequest(route: "/me/gallery/add-entry", body: requestData) {result in
            switch(result){
            case .success(var response):
                do{
                    let galleryImage = try response.parseData() as GalleryImage
                    print(galleryImage)
                    completionHandler(.success(galleryImage))
                    return
                }catch{
                    print("Unable to convert to JSON")
                    completionHandler(.failure(UserGalleryError.APIError(message: "Error Parsing JSON")))
                    return
                }
            case .failure(let error):
                switch error {
                case .ResponseError(let message):
                    completionHandler(.failure(.APIError(message: message ?? "API error")))
                    return
                default:
                    print(error)
                    completionHandler(.failure(.APIError(message: "Something went wrong")))
                    return
                }
            }
        }
    }
}
