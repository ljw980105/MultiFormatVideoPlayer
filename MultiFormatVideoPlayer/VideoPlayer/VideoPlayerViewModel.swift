//
//  VideoPlayerState.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import Foundation
import SwiftUI

class VideoPlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var progress: Double = 0
    @Published var currentTime: String = "00:00:00"
    @Published var remainingTime: String = "00:00:00"
    @Published var isControlsHidden = false
    
    var timer: Timer?
    private var workItem: DispatchWorkItem?
    
    func process(state: VideoPlayerPlayheadState) {
        progress = state.progress
        currentTime = state.currentTime.timeString
        remainingTime = state.remainingTime.timeString
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
}
