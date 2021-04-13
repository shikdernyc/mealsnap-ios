//
//  MealSnapAPIError.swift
//  MealSnap
//
//  Created by Asif Shikder on 4/11/21.
//

import Foundation

enum MealSnapAPIError : Error {
    case URLError
    case RequestBodyEncodingError
    case URLSessionError
    case FailToParseResponse
    case AuthorizationTokenError
    case ResponseError(message: String?)
}
