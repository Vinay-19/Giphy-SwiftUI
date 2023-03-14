//
//  HomeView.swift
//  Giphy
//
//  Created by Vinay Kumar Thapa on 2023-03-14.
//

import SwiftUI

import SDWebImageSwiftUI

struct HomeView: View {
    //Properties
    @State private var searchTerm: String = ""
    
    @ObservedObject var dataModel: DataModel
    
    @StateObject var viewModel = ViewModel(httpClient: HttpClient(urlsession: URLSession.shared))
    
    private let fileManager = LocalFileManager.instance
    
    private let imageFolder = Constants.imageFolderName
    
    @State var favId = [String]()
    
    var body: some View {
        VStack(spacing:20) {
            
            // Added custom searchBar on top of the screen
            SearchBar(text: $searchTerm)
            
            // Checking to display progressView and listView
            if viewModel.data.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }else{
                ScrollView {
                    ForEach(searchTerm.isEmpty ? viewModel.data : viewModel.searchData , id: \.self) { data in
                        let imageName = data.images?.original?.url ?? ""
                        ZStack {
                            WebImage(url: URL(string: imageName))
                                .placeholder {
                                    //ProgressView()
                                    ZStack{
                                        Rectangle().foregroundColor(.gray)
                                        ProgressView()
                                    }
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            Button(action: {
                                let imageId = data.id ?? ""
                                // checking the favourite id are exisitng in the array
                                if self.favId.contains(imageId) {
                                    fileManager.deleteImage(imageName: imageId, folderfName: imageFolder)
                                    dataModel.fileURLs = fileManager.getFolderDetails(folderName: imageFolder)!
                                    self.favId.removeAll{ $0 == imageId}
                                }else{
                                    self.favId.append(imageId)
                                    // saving image into file system
                                    DispatchQueue.global().async {
                                        guard let url = URL(string: imageName) else{ return}
                                        if let data = try? Data(contentsOf: url){
                                            DispatchQueue.main.async {
                                                fileManager.saveImage(imageData: data, imageName: imageId, folderName: imageFolder)
                                            }
                                        }
                                    }
                                }
                            }) {
                                
                                if self.favId.contains(data.id ?? "") {
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .foregroundColor(.yellow)
                                } else {
                                    Image(systemName: "heart")
                                        .resizable()
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: 25, height: 25, alignment: .topTrailing)
                            .offset(x: 160, y: -65)
                        }.listRowSeparator(.hidden)
                            .frame(height: 200)

                    } .padding(.all, 16)
                }
            }
        }
        .background(.white)
        .scrollContentBackground(.hidden)
        .onChange(of: searchTerm) { newValue in
            
            // Calling the search API
            viewModel.searchByGif(searchName: newValue)
            
        }.onAppear{
            
            // Calling the trending API
            viewModel.getTrendingGif()
            
            if let folder =  fileManager.getFolderDetails(folderName: imageFolder) {
                dataModel.fileURLs = folder
                favId = folder.map{$0.deletingPathExtension().lastPathComponent}
                print(favId)
            }
            
            /*
             deletingPathExtension(): Removing path extension
             lastPathComponent: Fething the last component of the path
             Original data in folder:
             Output: file:///Users/vinay/Library/Developer/CoreSimulator/Devices/6F4896D2-6AD7-4CFC-8744-DA206CA57124/data/Containers/Data/Application/4222AD01-2932-4E44-9F67-01EC1BBF5D11/Library/Caches/fav_images/U3dBhZ4bn5DlJOocr4.gif
             po folder.map{$0.deletingPathExtension()}
             Output: file:///Users/vinay/Library/Developer/CoreSimulator/Devices/6F4896D2-6AD7-4CFC-8744-DA206CA57124/data/Containers/Data/Application/4222AD01-2932-4E44-9F67-01EC1BBF5D11/Library/Caches/fav_images/U3dBhZ4bn5DlJOocr4
             po folder.map{$0.deletingPathExtension().lastPathComponent}
             Output: "U3dBhZ4bn5DlJOocr4"
             */
            
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataModel: .init())
    }
}
