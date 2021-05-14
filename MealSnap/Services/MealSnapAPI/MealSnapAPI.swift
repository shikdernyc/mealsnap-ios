//
//  BackendAPI.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/8/21.
//

import Foundation

typealias APIRequestCompletionHandler = (Result<MealSnapAPIResponse, MealSnapAPIError>) -> Void

struct MealSnapAPIErrorJSON : Decodable {
    var message: String?
}

struct MealSnapAPI {
    static func GetRequest(route: String, completionHandler: @escaping APIRequestCompletionHandler) -> Void {
        guard let url = URL(string: "\(ServiceConfig.MealSnapAPIRootURL)\(route)") else {
            completionHandler(.failure(.URLError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        AuthService.RetrieveJWTToken() {tokenResult in
            switch (tokenResult) {
            case .success(let token):
                request.setValue(token, forHTTPHeaderField: "Authorization")
                MakeRequest(with: request, completionHandler: completionHandler)
                return
            case .failure:
                completionHandler(.failure(MealSnapAPIError.AuthorizationTokenError))
                return
            }
        }
        
    }
    
    static func PostRequest<T: Encodable>(route:String, body: T, completionHandler: @escaping APIRequestCompletionHandler) {
        guard let url = URL(string: "\(ServiceConfig.MealSnapAPIRootURL)\(route)") else {
            completionHandler(.failure(.URLError))
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
            completionHandler(.failure(.RequestBodyEncodingError))
        }
        AuthService.RetrieveJWTToken() {tokenResult in
            switch (tokenResult) {
            case .success(let token):
                request.setValue(token, forHTTPHeaderField: "Authorization")
                MakeRequest(with: request, completionHandler: completionHandler)
                return
            case .failure:
                completionHandler(.failure(MealSnapAPIError.AuthorizationTokenError))
                return
            }
        }
    }
    
    private static func MakeRequest(with request: URLRequest, completionHandler: @escaping APIRequestCompletionHandler) {
        URLSession.shared.dataTask(with: request) {data, response, error in
            if error != nil {
                completionHandler(.failure(.URLSessionError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.FailToParseResponse))
                return
            }
            var response = MealSnapAPIResponse(response: httpResponse, data: data)
            guard (200...299).contains(httpResponse.statusCode) else {
                // TODO: Get Error
                do{
                    let jsonData = try response.parseData() as MealSnapAPIErrorJSON
                    print(httpResponse)
                    completionHandler(.failure(.ResponseError(message: jsonData.message)))
                    return
                }catch {
                    completionHandler(.failure(.ResponseError(message: nil)))
                    return
                }
            }
            completionHandler(.success(response))
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
