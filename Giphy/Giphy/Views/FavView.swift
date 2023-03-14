//
//  FavView.swift
//  Giphy
//
//  Created by Vinay Kumar Thapa on 2023-03-14.
//

import SwiftUI

struct FavView: View {
    //Properties
    @State private var selectedSegment = 0 //: A state variable to keep track of the selected segment in the picker. Default value is 0.
    @ObservedObject var dataModel: DataModel

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selectedSegment) {
                Text("Grid").tag(0)
                Text("List").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // if selectedSegment == 0: An if statement that checks if the first segment (Grid) is selected.
            
            if selectedSegment == 0 {
                FavGridView(dataModel: dataModel)
            } else {
                FavListView(dataModel: dataModel)
            }
            Spacer()
        }
    }
}

struct FavView_Previews: PreviewProvider {
    static var previews: some View {
        FavView(dataModel: .init())
    }
}

