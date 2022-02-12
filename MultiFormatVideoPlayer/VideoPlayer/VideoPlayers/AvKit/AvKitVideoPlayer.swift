//
//  AvKitVideoPlayer.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import UIKit
import AVKit

class AvKitVideoPlayer: UIView, VideoPlayable {
    var videoFile: VideoFile
    let player: AVPlayer
    
    init(videoFile: VideoFile) {
        self.videoFile = videoFile
        let asset = AVAsset(url: videoFile.url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player
        super.init(frame: .zero)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        guard let newSuperview = newSuperview else {
            return
        }
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = newSuperview.bounds
        playerLayer.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func goForwardFifteenSeconds() {
        let currentTime = player.currentTime()
        player.seek(to: currentTime + 15.cmTime)
    }
    
    func goBackwardsFifteenSeconds() {
        let currentTime = player.currentTime()
        player.seek(to: currentTime - 15.cmTime)
    }
    
    func update(progress: Double) {
        guard let asset = player.currentItem?.asset else {
            return
        }
        player.seek(to: CMTimeMultiplyByFloat64(asset.duration, multiplier: Float64(progress)))
    }
    
    var currentState: VideoPlayerPlayheadState {
        let currentTime = player.currentTime()
        guard let asset = player.currentItem?.asset else {
            return .default
        }
        return .init(progress: currentTime.double / asset.duration.double)
    }
}
