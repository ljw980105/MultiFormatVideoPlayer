//
//  PlayButton.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import SwiftUI

struct PlayButton: View {
    var body: some View {
        Triangle()
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .rotationEffect(.degrees(90))
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton()
    }
}
