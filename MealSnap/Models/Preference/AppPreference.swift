//
//  AppPreference.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/13/21.
//

import Foundation

typealias OnChangePreferenceListener<T> = (_ newValue : T) -> Void

class UserPreference {
    private static let HIDE_IMAGE_DETAIL_KEY = "HIDE_IMAGE_DETAIL"
    private static var HideImageDetailListender : [OnChangePreferenceListener<Bool>] = []
    
    static func HideImageDetail() -> Bool {
        return UserDefaults.standard.bool(forKey: UserPreference.HIDE_IMAGE_DETAIL_KEY)
    }
    
    static func HideImageDetail(onChange: @escaping OnChangePreferenceListener<Bool>) -> Void {
        UserPreference.HideImageDetailListender.append(onChange)
    }
    
    static func HideImageDetail(set to: Bool) {
        UserDefaults.standard.set(to, forKey: HIDE_IMAGE_DETAIL_KEY)
        for listender in HideImageDetailListender {
            listender(to)
        }
    }
}
