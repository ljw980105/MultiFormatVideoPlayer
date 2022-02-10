//
//  AvKitVideoPlayer.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import UIKit
import AVKit

class AvKitVideoPlayer: VideoPlayable {
    var player: AVPlayer?
    
    override init(videoFile: VideoFile) {
        super.init(videoFile: videoFile)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        guard let newSuperview = newSuperview else {
            return
        }
        let asset = AVAsset(url: videoFile.url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = newSuperview.bounds
        playerLayer.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func play() {
        self.player?.play()
    }
    
    override func pause() {
        self.player?.pause()
    }
}
