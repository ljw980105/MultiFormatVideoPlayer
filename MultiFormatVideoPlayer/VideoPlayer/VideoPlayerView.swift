//
//  VideoPlayerView.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import SwiftUI

fileprivate enum Styles {
    static var controlPanelGraident: Gradient {
        Gradient(stops: [
            .init(color: Color(red: 115/255, green: 115/255, blue: 115/255), location: 0),
            .init(color: .black, location: 0.8)
        ])
    }
    static var controlPanelStrokeColor: Color {
        .init(red: 152/255, green: 152/255, blue: 152/255)
    }
    static var topBarGraident: Gradient {
        Gradient(stops: [
            .init(color: Color(red: 44/255, green: 44/255, blue: 44/255), location: 0),
            .init(color: .black, location: 0.3)
        ])
    }
    static var doneButtonGraident: Gradient {
        Gradient(stops: [
            .init(color: Color(red: 125/255, green: 153/255, blue: 227/255), location: 0),
            .init(color: Color(red: 53/255, green: 97/255, blue: 213/255), location: 0.7)
        ])
    }
    static var thumbRadius: CGFloat { 30 }
}

struct VideoPlayerView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isUnsupported = false
    @StateObject var state: VideoPlayerState = .init()
    let file: VideoFile
    let callbacks: VideoPlayerCallbacks
    
    init(file: VideoFile) {
        self.file = file
        self.callbacks = .init()
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VideoPlayerContainer(
                    videoFile: file,
                    callbacks: callbacks,
                    isPlaying: $state.isPlaying
                )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            state.isControlsHidden.toggle()
                        }
                    }
                VStack {
                    HStack(alignment: .center, spacing: 0) {
                        FixedWidthSpacer(length: 20)
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Done")
                                .padding(10)
                                .background(LinearGradient(gradient: Styles.doneButtonGraident, startPoint: .top, endPoint: .bottom))
                                .cornerRadius(5)
                                .foregroundColor(.white)
                        })
                        FixedWidthSpacer(length: 20)
                        Slider(value: $state.progress, label: {
                            Text("Sth")
                        }, minimumValueLabel: {
                            Text($state.currentTime.wrappedValue)
                                .foregroundColor(.white)
                        }, maximumValueLabel: {
                            Text($state.remainingTime.wrappedValue)
                                .foregroundColor(.white)
                        }, onEditingChanged: { isEditing in
                            if isEditing {
                                stopTimer()
                                state.isPlaying = false
                            } else {
                                startTimer()
                                state.isPlaying = true
                                callbacks.updateProgress?(state.progress)
                            }
                        })
                        FixedWidthSpacer(length: 40)
                    }
                        .frame(height: 60)
                        .background(LinearGradient(gradient: Styles.controlPanelGraident, startPoint: .top, endPoint: .bottom))
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Styles.controlPanelStrokeColor, lineWidth: 5)
                                .background(
                                    RoundedRectangle(cornerRadius: 20).fill(
                                        LinearGradient(gradient: Styles.controlPanelGraident, startPoint: .top, endPoint: .bottom)
                                    )
                                )
                                .frame(width: 300, height: 120)
        
                                .opacity(0.5)
                            VStack {
                                Text(file.fileName)
                                    .font(.headline)
                                HStack {
                                    FixedWidthSpacer(length: 20)
                                    BackwardButton()
                                        .onTapGesture {
                                            callbacks.seekBackward?()
                                        }
                                    FixedWidthSpacer(length: 40)
                                    ZStack {
                                        PlayButton()
                                            .opacity(state.isPlaying ? 0 : 1)
                                        PauseButton()
                                            .opacity(state.isPlaying ? 1 : 0)
                                        TappableArea(width: 40, height: 40)
                                            .onTapGesture {
                                                state.isPlaying.toggle()
                                            }
                                    }
                                    FixedWidthSpacer(length: 40)
                                    ForwardButton()
                                        .onTapGesture {
                                            callbacks.seekForward?()
                                        }
                                    FixedWidthSpacer(length: 20)
                                }
                            }
                            .padding(.init(top: 5, leading: 5, bottom: 10, trailing: 5))
                        }
                        Spacer()
                    }
                }
                .opacity(state.isControlsHidden ? 0 : 1)
            }
            .onAppear {
                isUnsupported = file.ext == .unknown
                stopTimer()
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
            .padding(.init(top: 10, leading: 0, bottom: 20, trailing: 0))
            .alert("This video format is not supported", isPresented: $isUnsupported) {
                Button("OK", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func stopTimer() {
        state.timer?.invalidate()
    }
    
    func startTimer() {
        state.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if let state = callbacks.getCurrentState?() {
                self.state.process(state: state)
            }
        }
    }
}
