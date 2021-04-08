//
//  BackendAPI.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/8/21.
//

import Foundation

typealias APIRequestCompletionHandler = (Result<Data?, Error>) -> Void

enum MealSnapAPIError : Error {
    case InvalidRoute(String)
    case ServerError(HTTPURLResponse?)
    case RequestBodyEncodingError
}

struct MealSnapAPI {
    static func GetRequest(route: String, completionHandler: @escaping APIRequestCompletionHandler) -> Void {
        guard let url = URL(string: "\(ServiceConfig.MealSnapAPIRootURL)\(route)") else {
            completionHandler(.failure(MealSnapAPIError.InvalidRoute("Error Creating URL")))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        MakeRequest(with: request, completionHandler: completionHandler)
    }
    
    static func PostRequest<T: Encodable>(route:String, body: T, completionHandler: @escaping APIRequestCompletionHandler) {
        guard let url = URL(string: "\(ServiceConfig.MealSnapAPIRootURL)\(route)") else {
            completionHandler(.failure(MealSnapAPIError.InvalidRoute("Error Creating URL")))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do{
            var jsonData: Data
            jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }catch {
            completionHandler(.failure(MealSnapAPIError.RequestBodyEncodingError))
        }
        MakeRequest(with: request, completionHandler: completionHandler)
    }
    
    private static func MakeRequest(with request: URLRequest, completionHandler: @escaping APIRequestCompletionHandler) {
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let httpResposne = response as? HTTPURLResponse, (200...299).contains(httpResposne.statusCode) else {
                completionHandler(.failure(MealSnapAPIError.ServerError(response as? HTTPURLResponse)))
                return
            }
            completionHandler(.success(data))
        }.resume()
    }
}

extension MealSnapAPI {
    static func CheckConnection(completionHandler: @escaping((Result<Bool, Error>) -> Void)) {
        GetRequest(route: "") {result in
            switch (result) {
            case .success:
                completionHandler(.success(true))
                return
            case .failure(let error):
                print(error)
                completionHandler(.failure(error))
                return
            }
        }
    }
}
