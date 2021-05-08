//
//  Image.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/7/21.
//

import Foundation
import UIKit

class ImageService {
    private static let ImageCache = NSCache<NSString, UIImage>()

    
    static func fetch(imageUrl: String, callback: @escaping((Result<UIImage, Error>) -> Void)) {
        if let cachedImage = ImageCache.object(forKey: imageUrl as NSString) {
            callback(.success(cachedImage))
            return
        }
        let url = URL(string: imageUrl)
        URLSession.shared.dataTask(with: url!) {data,response,error in
            if error != nil {
                callback(.failure(error!))
                return
            }
            DispatchQueue.main.async {
                let uiImage = UIImage(data: data!)
                ImageCache.setObject(uiImage!, forKey: imageUrl as NSString)
                callback(.success(uiImage!))
            }
        }.resume()
    }
}
