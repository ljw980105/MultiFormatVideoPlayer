//
//  VideoPlayerCallbacks.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import Foundation

class VideoPlayerCallbacks {
    var seekForward: (() -> Void)?
    var seekBackward: (() -> Void)?
    var startedDraggingSlider: (() -> Void)?
    var endedDraggingSlider: (() -> Void)?
}
