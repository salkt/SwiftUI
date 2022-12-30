//
//  TileView.swift
//  ex-YourLuck
//
//  Created by Mac on 2022/12/21.
//

import SwiftUI
import Colorful

struct TileView: View {
    let image: String
    let title: String
    let width: CGFloat
    let height: CGFloat
    let color: Color
    var body: some View {
        VStack {
            ExMenuMiew(image: image, title: title, count: 0, today: Date())
                .frame(width: width, height: height)
        }.foregroundColor(.white)
            .background(
                GlassBackGround(width: width, height: height, color: color)
                    .shadow(color: .black, radius: 2, x: 2, y: 2)
            )
    }
}

struct GlassBackGround: View {
    
    let width: CGFloat
    let height: CGFloat
    let color: Color
    
    var body: some View {
        ZStack{
            RadialGradient(colors: [.clear, color],
                           center: .center,
                           startRadius: 1,
                           endRadius: 100)
                .opacity(0.5)
            Rectangle().foregroundColor(color)
        }
        .opacity(0.1)
        .blur(radius: 2)
        .cornerRadius(10)
        .frame(width: width, height: height)
    }
}

struct ExMenuMiew: View {
    var image: String
    var title: String
    var count: Int
    var today: Date
    var body: some View {
        VStack{
            HStack{
                Image(systemName: image)
                Spacer()
                //Text("\(Calendar.current.date(byAdding: .day, value: -count, to: today)!)")
            }
            .font(.largeTitle)
            HStack{
                Text(title)
                Spacer()
            }
            .font(.title)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8.0)
    }
}


struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(image: "calendar.circle.fill", title: "today", width: 180, height: 100, color: .black)
    }
}
