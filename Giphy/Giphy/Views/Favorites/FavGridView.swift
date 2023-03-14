//
//  FavGridView.swift
//  Giphy
//
//  Created by Vinay Kumar Thapa on 2023-03-14.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavGridView: View {
    @ObservedObject var dataModel: DataModel
    private let fileManager = LocalFileManager.instance
    private let imageFolder = Constants.imageFolderName
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]
    var body: some View {
        // Your grid view content here
        ScrollView{
            
            if dataModel.fileURLs.isEmpty {
                Text("No saved gifs")
            }else{
            
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(dataModel.fileURLs, id: \.self) { imageName in
                        ZStack {
                            WebImage(url: imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            Button(action: {
                                print("button tapped")
                                let url = imageName.deletingPathExtension().lastPathComponent
                                fileManager.deleteImage(imageName: url, folderfName: imageFolder)
                                dataModel.fileURLs = fileManager.getFolderDetails(folderName: imageFolder)!
                            }) {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .foregroundColor(.yellow)
                                
                            }
                            .frame(width: 20, height: 20, alignment: .topTrailing)
                            .offset(x: 40, y: -35)
                        }.frame(height: 100)
                    }
                    
                }.padding([.leading,.trailing], 16)
            }
       
        }.onAppear{
            if let folder =  fileManager.getFolderDetails(folderName: imageFolder) {
                dataModel.fileURLs = folder
            }
        }
    }
}

struct FavGridView_Previews: PreviewProvider {
    static var previews: some View {
        FavGridView(dataModel: .init())
    }
}
