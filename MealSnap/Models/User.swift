//
//  Search.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/3/21.
//

import Foundation

struct UserSummary : Decodable {
    let userId: String
    let userName: String
    var firstName: String? = nil
    var lastName: String? = nil
}

struct SearchUserEntry : Decodable {
    let id: String
    let username: String
    let firstName: String?
    let lastName: String?
}

struct SearchUserResponse : Decodable {
    let users: [SearchUserEntry]
}

enum UserError : Error {
    case UserNotFound
    case APIError(message: String? = nil)
}

class User {
    static func FindUser(query: String, callback: @escaping ((Result<[UserSummary], UserError>) -> Void)) {
        if query.count == 0 {
            callback(.success([]))
            return
        }
        let url = "/search/user?query=" + query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!;
        MealSnapAPI.GetRequest(route: url) {result in
            switch(result){
            case .success(var response):
                do {
                    let parsedResponse = try response.parseData() as SearchUserResponse
                    print(parsedResponse)
                    let userModels = parsedResponse.users.map {UserSummary(
                        userId: $0.id,
                        userName: $0.username,
                        firstName: $0.firstName,
                        lastName: $0.lastName
                    )}
                    callback(.success(userModels))
                } catch let error {
                    print(error)
                    callback(.failure(.APIError()))
                }
                return
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}
