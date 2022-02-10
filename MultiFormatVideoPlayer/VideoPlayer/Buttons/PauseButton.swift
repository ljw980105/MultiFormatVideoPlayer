//
//  PauseButton.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import SwiftUI

struct PauseButton: View {
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 10, height: 40)
                .foregroundColor(.white)
            Rectangle()
                .frame(width: 10, height: 40)
                .foregroundColor(.white)
        }
    }
}

struct PauseButton_Previews: PreviewProvider {
    static var previews: some View {
        PauseButton()
    }
}
