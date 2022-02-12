//
//  VideoPlayerState.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import Foundation
import SwiftUI

class VideoPlayerState: ObservableObject {
    @Published var isPlaying = false
    @Published var progress: Double = 0
    var timer: Timer?
    
    func process(state: VideoPlayerPlayheadState) {
        progress = state.progress
    }
}
