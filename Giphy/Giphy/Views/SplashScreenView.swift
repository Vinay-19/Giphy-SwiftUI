//
//  SplashScreenView.swift
//  Giphy
//
//  Created by Vinay Kumar Thapa on 2023-03-14.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    
    var body: some View {
        
        if isActive {
            ContentView()
        }else{
            
            VStack{
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Text("Giphy").font(.title).bold()
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    isActive.toggle()
                }
                
            }
        
    }
        
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
