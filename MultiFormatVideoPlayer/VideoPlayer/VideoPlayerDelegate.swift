//
//  VideoPlayerDelegate.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import Foundation

protocol VideoPlayerDelegate: AnyObject {
    func videoPlayer(
        _ videoPlayer: VideoPlayable,
        didChangeTime time: Double,
        totalDuration: Double,
        progress: Double
    )
}
