//
//  DataView.swift
//  ex-YourLuck
//
//  Created by Mac on 2022/12/21.
//

import SwiftUI

struct DataView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    NavigationLink(destination: SearchedByDateView(viewModel: viewModel, value: 0)){
                        TileView(image: "calendar.circle", title: "Today", width: 185, height: 100, color: .black)
                    }
                    NavigationLink(destination: SearchedByDateView(viewModel: viewModel, value: 1)){
                        TileView(image: "calendar.circle.fill", title: "Yesterday", width: 185, height: 100, color: .black)
                    }
                }
                NavigationLink(destination: SearchedByDateView(viewModel: viewModel, value: 2)){
                    TileView(image: "calendar", title: "This week", width: 380, height: 100, color:.black)
                }
                NavigationLink(destination: SearchedByTextView(viewModel: viewModel)){
                    TileView(image: "tray.full", title: "All", width: 380, height: 100, color:.black)
                }
                Spacer()
            }
            .navigationTitle("Data")
        }
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView(viewModel: ViewModel())
    }
}
