//
//  DataModel.swift
//  Giphy
//
//  Created by Vinay Kumar Thapa on 2023-03-14.
//

import Foundation

class DataModel: ObservableObject {
    @Published var fileURLs = [URL]()
    private let fileManager = LocalFileManager.instance
    private let imageFolder = Constants.imageFolderName
    
    init() {
        if let folder =  fileManager.getFolderDetails(folderName: imageFolder) {
            fileURLs = folder
        }
    }
}
