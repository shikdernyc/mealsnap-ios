//
//  UIImageView.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/13/21.
//

import UIKit

@objc protocol UIImageViewSetImageUrlDelegate {
    @objc optional func onImageSetByUrl() -> Void
    @objc optional func onImageSetByUrlError(error: Error) -> Void
}

extension UIImageView {
    private static let ImageCache = NSCache<NSString, UIImage>()
    
    private static func FetchImage(imageUrl: String, callback: @escaping((Result<UIImage, Error>) -> Void)) {
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
    
    func setImage(url: String, delegate: UIImageViewSetImageUrlDelegate? = nil) {
        UIImageView.FetchImage(imageUrl: url) { result in
            switch(result){
            case .success(let image):
                self.image = image
                delegate?.onImageSetByUrl?()
                return
            case .failure(let error):
                // TODO: Need Better Error Handling
                delegate?.onImageSetByUrlError?(error: error)
                print(error)
            }
        }
    }
}
