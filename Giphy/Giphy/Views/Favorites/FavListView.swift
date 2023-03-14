//
//  FavListView.swift
//  Giphy
//
//  Created by Vinay Kumar Thapa on 2023-03-14.
//

import SwiftUI

import SDWebImageSwiftUI

struct FavListView: View {
    @ObservedObject var dataModel: DataModel
    
    @State var gridLayout: [GridItem] = [ GridItem() ]
    private let fileManager = LocalFileManager.instance
    private let imageFolder = "fav_images"
    
    var body: some View {
        // Your list view content here
        ScrollView {
            
            if dataModel.fileURLs.isEmpty {
                Text("No saved gifs")
            }else{
                
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
              
                    ForEach(dataModel.fileURLs, id: \.self) { imageName in
                        ZStack {
                            WebImage(url: imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
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
                            .offset(x: 160, y: -65)
                        }.frame(height: 200)
                    }
                }
                .padding([.leading,.trailing], 16)
        }
        
        }.onAppear{
            if let folder =  fileManager.getFolderDetails(folderName: imageFolder) {
                dataModel.fileURLs = folder
            }
        }
    }
}

struct FavListView_Previews: PreviewProvider {
    static var previews: some View {
        FavListView(dataModel: .init())
    }
}

