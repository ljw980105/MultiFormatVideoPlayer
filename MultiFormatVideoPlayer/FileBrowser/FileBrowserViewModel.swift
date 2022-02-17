//
//  FileBrowserViewModel.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/9/22.
//

import Foundation
import SwiftUI

class FileBrowserViewModel: ObservableObject {
    @Published var files: [VideoFile] = []
    
    init() {
        let fileManager = FileManager.default
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
           let enumerator = fileManager.enumerator(at: documentsDirectory, includingPropertiesForKeys: [.isRegularFileKey]) {
            var _files: [URL] = []
            for case let fileURL as URL in enumerator {
                if (try? fileURL.resourceValues(forKeys:[.isRegularFileKey]))?.isRegularFile ?? false {
                    _files.append(fileURL)
                }
            }
            files = _files.compactMap(VideoFile.init)
        }
        
    }
    
    func deleteVideo(at indexSet: IndexSet) {
        let file = files[indexSet.index]
        do {
            try FileManager.default.removeItem(at: file.url)
        } catch {
            print(error)
        }
        files.remove(atOffsets: indexSet)
    }
}

extension IndexSet {
    var index: Int {
        self[startIndex]
    }
}
