//
//  ResumePlaybackManager.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/16/22.
//

import Foundation

/// For the use case when the user wants to resume playback from a certain time
enum ResumePlaybackManager {
    
    private static var userDefaults: UserDefaults { .standard }
    
    static func setPlaybackDuration(_ duration: Double, for videoFile: VideoFile) {
        userDefaults.set(duration, forKey: videoFile.defaultsKey)
    }
    
    static func getPlaybackDuration(for videoFile: VideoFile) -> Double {
        userDefaults.double(forKey: videoFile.defaultsKey)
    }
    
    static func deletePlaybackDuration(for videoFile: VideoFile) {
        userDefaults.removeObject(forKey: videoFile.defaultsKey)
    }
}

fileprivate extension VideoFile {
    var defaultsKey: String {
        "duration_\(url.absoluteString)"
    }
}
