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
    
    func play()
    func pause()
    func goForwardFifteenSeconds()
    func goBackwardsFifteenSeconds()
    func update(isPlaying: Bool)
    func update(progress: Double)
}

extension VideoPlayable {
    func update(isPlaying: Bool) {
        isPlaying ? play() : pause()
    }
}

struct VideoPlayerPlayheadState {
    /// value ranges from 0 to 1
    let progress: Double
    
    static let `default`: VideoPlayerPlayheadState = .init(progress: 0)
}
