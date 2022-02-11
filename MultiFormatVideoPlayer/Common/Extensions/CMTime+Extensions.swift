//
//  CMTime+Extensions.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import CoreMedia

extension Double {
    /// `CMTime` Logic
    /// Seconds = value / timescale
    var cmTime: CMTime {
        CMTimeMake(value: Int64(self * 10000), timescale: 10000)
    }
}

extension CMTime {
    var double: Double {
        Double(value) / Double(timescale)
    }
    
    static func +(lhs: CMTime, rhs: CMTime) -> CMTime {
        CMTimeAdd(lhs, rhs)
    }
    
    static func -(lhs: CMTime, rhs: CMTime) -> CMTime {
        CMTimeSubtract(lhs, rhs)
    }
}
