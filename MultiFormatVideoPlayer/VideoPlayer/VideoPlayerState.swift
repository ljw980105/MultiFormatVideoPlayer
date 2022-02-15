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
    @Published var currentTime: String = "00:00:00"
    @Published var remainingTime: String = "00:00:00"
    @Published var isControlsHidden = false
    
    var timer: Timer?
    
    func process(state: VideoPlayerPlayheadState) {
        progress = state.progress
        currentTime = state.currentTime.timeString
        remainingTime = state.remainingTime.timeString
    }
}
