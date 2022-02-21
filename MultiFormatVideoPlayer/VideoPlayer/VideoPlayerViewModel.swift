//
//  VideoPlayerViewModel.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import Foundation
import SwiftUI

class VideoPlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var progress: Double = 0
    @Published var currentTime: Double = 0
    @Published var remainingTime: Double = 0
    @Published var isControlsHidden = false
    
    var timer: Timer?
    private var workItem: DispatchWorkItem?
    
    func process(state: VideoPlayerPlayheadState) {
        progress = state.progress
        currentTime = state.currentTime
        remainingTime = state.remainingTime
    }
    
    func autoHideUI() {
        if !isControlsHidden {
            cancelAutoHide()
            let workItem = DispatchWorkItem { [weak self] in
                withAnimation(.easeInOut(duration: 0.3)) {
                    self?.isControlsHidden = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem)
            self.workItem = workItem
        }
    }
    
    func cancelAutoHide() {
        workItem?.cancel()
    }
    
    func resumeFromLeftOff(videoFile: VideoFile) {
        currentTime = ResumePlaybackManager.getPlaybackDuration(for: videoFile)
    }
}
