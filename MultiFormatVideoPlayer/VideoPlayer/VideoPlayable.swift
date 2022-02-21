//
//  VideoPlayable.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import Foundation
import UIKit

protocol VideoPlayable where Self: UIView {
    var videoFile: VideoFile { get set }
    var currentState: VideoPlayerPlayheadState { get }
    var lastPlayTime: Double { get }
    
    func play()
    func pause()
    func goForwardFifteenSeconds()
    func goBackwardsFifteenSeconds()
    func update(isPlaying: Bool)
    func update(progress: Double)
    /// Use the `lastPlaytime` property to seek to the last play time
    func seekToLastPlayTime()
}

extension VideoPlayable {
    func update(isPlaying: Bool) {
        isPlaying ? play() : pause()
        UIApplication.shared.isIdleTimerDisabled = isPlaying
    }
    
    var lastPlayTime: Double {
        ResumePlaybackManager.getPlaybackDuration(for: videoFile)
    }
}

struct VideoPlayerPlayheadState {
    /// value ranges from 0 to 1
    let progress: Double
    /// in seconds
    let currentTime: Double
    /// in seconds
    let remainingTime: Double
    
    static let `default`: VideoPlayerPlayheadState = .init(
        progress: 0,
        currentTime: 0,
        remainingTime: 0
    )
}
