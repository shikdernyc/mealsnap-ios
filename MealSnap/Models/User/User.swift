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
}

struct SearchUserEntry :Decodable {
    let id: String
    let username: String
}

struct SearchUserResponse : Decodable {
    let users: [SearchUserEntry]
}

enum UserError : Error {
    case UserNotFound
    case APIError(message: String? = nil)
}

class User {
    static func FindUser(username: String, callback: @escaping ((Result<[UserSummary], UserError>) -> Void)) {
        let url = "/search/user?username=" + username;
        MealSnapAPI.GetRequest(route: url) {result in
            switch(result){
            case .success(var response):
                do {
                    let parsedResponse = try response.parseData() as SearchUserResponse
                    let userModels = parsedResponse.users.map {UserSummary(userId: $0.id, userName: $0.username) }
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
