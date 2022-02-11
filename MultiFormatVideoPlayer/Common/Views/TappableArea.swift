//
//  TappableArea.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import SwiftUI

/// A tappable area view which a non zero opacity rectangle to not be considered empty
/// which increases tappable area
struct TappableArea: View {
    let width: CGFloat
    let height: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.001))
    }
}
