//
//  AudioService.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/8/21.
//

import Foundation
import AVFoundation

enum AudioServiceSound {
    case Refresh
}

enum AudioServiceError : Error {
    case FileDoesntExists
}

class AudioService {
    private static let ResourceMapper: [AudioServiceSound:String] = [
        AudioServiceSound.Refresh: "woosh"
    ]
    
    static func Player(for sound: AudioServiceSound) throws -> AVAudioPlayer{
        guard let filePath = Bundle.main.path(forResource: ResourceMapper[sound], ofType: "mp3") else {
            throw AudioServiceError.FileDoesntExists
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
            return player
        }catch let error {
            throw error
        }
    }
}
