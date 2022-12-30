//
//  HomeView.swift
//  ex-YourLuck
//
//  Created by Mac on 2022/12/21.
//

import SwiftUI
import DynamicColor

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: ViewModel
    @AppStorage("lucky_count") var lucky_count = 0
    @AppStorage("unlucky_count") var unlucky_count = 0
    var body: some View {
        VStack{
            Spacer()
            Text("Home")
            Spacer()
            HStack{
                Spacer()
                Text("\(unlucky_count)")
                    .font(.largeTitle)
                Spacer()
                Text("\(lucky_count)")
                    .font(.largeTitle)
                Spacer()
            }
            Spacer()
            HStack{
                Spacer()
                LikeView(viewModel: viewModel, likeColor: .indigo, likeOverlay: .cyan, likeBackground: .white, isLucky: false)
                    .frame(width: 100, height: 100)
                    .scaleEffect(0.5)
                Spacer()
                LikeView(viewModel: viewModel, likeColor: .red, likeOverlay: .pink, likeBackground: .white, isLucky: true)
                    .frame(width: 100, height: 100)
                    .scaleEffect(0.5)
                Spacer()
            }
            Spacer()
            TextField("memo", text: $viewModel.memo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(20)
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: ViewModel())
    }
}
