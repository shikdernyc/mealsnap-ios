//
//  MealSnapAPIResponse.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/11/21.
//

import Foundation

enum MealSnapAPIResponseError : Error {
    case UnableToParseData
    case DataDoesntExist
}

enum APIStatus {
    case InfoResponse
    case Ok
    case Created
    case Redirects
    case ClientError
    case UnAuthorized
    case ServerError
    
    static func GetError(statusCode: Int) -> APIStatus {
        switch statusCode {
        case (100...199):
            return .InfoResponse
        case 201:
            return .Created
        case (200...299):
            return .Ok
        case (300...399):
            return .Redirects
        case 401:
            return .UnAuthorized
        case (400...499):
            return .ClientError
        default:
            return .ServerError
        }
    }
    
}

struct MealSnapAPIResponse {
    let status: APIStatus
    let data: Data?
    private var cachedJSON: Any?
    
    init(response: HTTPURLResponse, data: Data? = nil) {
        self.data = data
        self.status = APIStatus.GetError(statusCode: response.statusCode)
        self.cachedJSON = nil
    }
    
    mutating func parseData<T: Decodable>() throws -> T {
        if cachedJSON != nil {
            return cachedJSON as! T
        }
        do{
            guard data != nil else {
                throw MealSnapAPIResponseError.DataDoesntExist
            }
            self.cachedJSON = try JSONDecoder().decode(T.self, from: data!)
            return self.cachedJSON as! T
        }catch {
            throw MealSnapAPIResponseError.UnableToParseData
        }
    }
}
