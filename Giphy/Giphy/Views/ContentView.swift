//
//  ContentView.swift
//  Giphy
//
//  Created by Vinay Kumar Thapa on 2023-03-13.
//

import SwiftUI

struct ContentView: View {
    
    init() {
       // UITabBar.appearance().backgroundColor = UIColor.white
    }
   
    @ObservedObject var data = DataModel()
    
    var body: some View {
        TabView {
            HomeView(dataModel: data)
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("ALL Gifs")
                }
            FavView(dataModel: data)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorite Gifs")
                }
        }.background(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
