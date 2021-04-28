//
//  Post.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/8/21.
//

import Foundation

class UserGallery {
    private var galleryImages: [GalleryImage]
    private var nextPage: String?
    private var paginating: Bool
    
    private init(items: [GalleryImage], page: MealSnapAPIPageResponse? = nil) {
        self.galleryImages = items
        nextPage = page?.next
        self.paginating = false
    }
    
    func items() -> [GalleryImage] {
        return self.galleryImages
    }
    
    func canFetchMore() -> Bool {
        return self.paginating == false && self.nextPage != nil
    }
    
    func loadMore(handler: @escaping ((Result<Bool, UserGalleryError>) -> Void)) {
        // TODO: call next page
        guard let url = nextPage else {
            return
        }
        self.paginating = true
        MealSnapAPI.GetRequest(route: url) { result in
            do {
                let response = try UserGallery.ParseUserGalleryResponse(result: result)
                self.galleryImages.append(contentsOf: response.result)
                self.nextPage = response.page?.next
                handler(.success(true))
                self.paginating = false
                return
            }catch let error {
                self.paginating = false
                switch(error) {
                case let apiError as UserGalleryError:
                    handler(.failure(apiError))
                    return
                default:
                    handler(.failure(UserGalleryError.APIError(message: "Something went wrong")))
                }
            }
        }
    }
}

extension UserGallery {
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
        MealSnapAPI.PostRequest(route: "/me/gallery/add-entry", body: requestData) {result in
            switch(result){
            case .success(var response):
                do{
                    let galleryImage = try response.parseData() as GalleryImage
                    completionHandler(.success(galleryImage))
                    return
                }catch{
                    completionHandler(.failure(UserGalleryError.APIError(message: "Error Parsing JSON")))
                    return
                }
            case .failure(let error):
                switch error {
                case .ResponseError(let message):
                    completionHandler(.failure(.APIError(message: message ?? "API error")))
                    return
                default:
                    completionHandler(.failure(.APIError(message: "Something went wrong")))
                    return
                }
            }
        }
    }
    
    private static func ParseUserGalleryResponse(result: Result<MealSnapAPIResponse, MealSnapAPIError>) throws -> FetchGalleryImageForUserResponse {
        switch(result){
        case .success(var response):
            do {
                let galleryResponse = try response.parseData() as FetchGalleryImageForUserResponse
                return galleryResponse
            } catch {
                throw UserGalleryError.APIError(message: "Unable to convert to JSON")
            }
        case .failure(let error):
            switch error {
            case .ResponseError(let message):
                throw UserGalleryError.APIError(message: message ?? "API error")
            default:
                throw UserGalleryError.APIError(message: "Something went wrong")
            }
        }
    }
    
    static func GetGalleryForUser(
        userId: String,
        handler: @escaping (Result<UserGallery, UserGalleryError>) -> Void) {
        let url = "/user/" + userId + "/gallery"
        
        MealSnapAPI.GetRequest(route: url) { result in
            do {
                let response = try ParseUserGalleryResponse(result: result)
                let gallery = UserGallery(items: response.result, page: response.page)
                handler(.success(gallery))
                return
            }catch let error {
                switch(error) {
                case let apiError as UserGalleryError:
                    handler(.failure(apiError))
                    return
                default:
                    handler(.failure(UserGalleryError.APIError(message: "Something went wrong")))
                }
            }
        }
    }
}
