//
//  VideoPlayable.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import Foundation
import UIKit

class VideoPlayable: UIView {
    let videoFile: VideoFile
    
    init(videoFile: VideoFile) {
        self.videoFile = videoFile
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {}
    func pause() {}
}
