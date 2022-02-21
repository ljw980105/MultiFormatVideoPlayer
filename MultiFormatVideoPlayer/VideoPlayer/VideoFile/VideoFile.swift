//
//  VideoFile.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/9/22.
//

import Foundation
import AVKit
import MobileCoreServices

struct VideoFile {
    let ext: VideoFileExtension
    let fileName: String
    let url: URL
    
    init(url: URL) {
        ext = VideoFileExtension(rawValue: url.pathExtension) ?? .unknown
        fileName = url.lastPathComponent
        self.url = url
    }
    
    func makeView() -> VideoPlayable {
        ext.supportedVideoPlayer?.makeView(videoFile: .init(url: url))
        ?? DummyVideoPlayer(videoFile: .init(url: url))
    }
}

enum VideoFileExtension: String {
    case mp4
    case mpg
    case avi
    case m4v
    case _3gp = "3gp"
    case mkv
    case rmvb
    case unknown
    
    var supportedVideoPlayer: VideoPlayerType? {
        switch self {
        case .unknown:
            return nil
        case .rmvb, .mkv:
            return nil
        default:
            let avTypes = AVURLAsset.audiovisualTypes()
            /// ["mqv", "pls", "aifc", "m4r", "wav", "3gp", "3g2", "flac", "avi", "m2a", "aac", "mpa", "xhe", "m3u", "mov",
            /// "aiff", "ttml", "m4v", "amr", "caf", "m4a", "m4b", "mp4", "mp1", "m1a", "mp4", "aax", "mp2", "w64", "aa",
            /// "mp3", "itt", "au", "eac3", "webvtt", "vtt", "ac3", "m4p", "loas"]
            let avExtensions = avTypes.compactMap {
                UTTypeCopyPreferredTagWithClass($0 as CFString, kUTTagClassFilenameExtension)?.takeRetainedValue() as String?
            }
            return avExtensions.contains(rawValue) ? .avKit : nil
        }
    }
}

enum VideoPlayerType {
    case avKit
    
    func makeView(videoFile: VideoFile) -> VideoPlayable {
        switch self {
        case .avKit: return AvKitVideoPlayer(videoFile: videoFile)
        }
    }
}
