//
//  FixedWidthSpacer.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import SwiftUI

struct FixedWidthSpacer: View {
    let length: CGFloat
    
    init(length: CGFloat) {
        self.length = length
    }
    
    var body: some View {
        Rectangle()
            .frame(width: length, height: 20)
            .foregroundColor(.clear)
    }
}
