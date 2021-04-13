//
//  Post.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/8/21.
//

import Foundation

struct GalleryImage {
    let title: String
    let description: String
    let imageUrl: String
}

enum UserGalleryError : Error {
    case APIError
}

struct UserGallery {
    static func AddImage(
        title: String,
        description: String,
        imageData: Data,
        completionHandler: @escaping (Result<GalleryImage, Error>) -> Void) {
        let requestData = [
            "title": title,
            "description": description,
            "encodedImage": imageData.base64EncodedString()
        ]
        // TODO: Call the appropriate route
        MealSnapAPI.PostRequest(route: "/me/gallery/add-entry", body: requestData) {result in
            switch(result){
            case .success(let data):
                guard data != nil else {
                    completionHandler(.failure(UserGalleryError.APIError))
                    return
                }
                do{
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(jsonData)
                    completionHandler(.success(GalleryImage(
                        title: title, description: description, imageUrl: ""
                    )))
                    return
                }catch{
                    print("Unable to convert to JSON")
                    completionHandler(.failure(UserGalleryError.APIError))
                    return
                }
            case .failure(let error):
                completionHandler(.failure(error))
                return
            }
        }
    }
}
