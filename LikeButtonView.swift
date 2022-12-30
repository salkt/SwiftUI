//
//  LikeButtonView.swift
//  ex-YourLuck
//
//  Created by Mac on 2022/12/29.
//

import SwiftUI

struct LikeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: ViewModel
    
    // MARK:- variables
    let animationDuration: Double = 0.25
    
    @State var isAnimating: Bool = false
    @State var shrinkIcon: Bool = false
    @State var floatLike: Bool = false
    @State var showFlare: Bool = false
    
    let likeColor: Color
    let likeOverlay: Color
    let likeBackground: Color
    let isLucky: Bool
    //新しい構造体を作らずにそのまま初期化なしのプロパティとして宣言して、構造体作成時に初期化しよう。
    
    // MARK:- views
    var body: some View {
        ZStack {
            likeBackground
                .edgesIgnoringSafeArea(.all)
            ZStack {
                if (floatLike) {
                    CapusuleGroupView(isAnimating: $floatLike, likeColor: self.likeColor)
                        .offset(y: -130)
                        .scaleEffect(self.showFlare ? 1.25 : 0.8)
                        .opacity(self.floatLike ? 1 : 0)
                        .animation(Animation.spring().delay(animationDuration / 2))
                }
                Circle()
                    .foregroundColor(self.isAnimating ? likeColor : likeOverlay)
                    .animation(Animation.easeOut(duration: animationDuration * 2).delay(animationDuration))
                HeartImageView()
                    .foregroundColor(.white)
                    .offset(y: 12)
                    .scaleEffect(self.isAnimating ? 1.25 : 1)
                    .overlay(
                        Color.pink
                            .mask(
                                HeartImageView()
                            )
                            .offset(y: 12)
                            .scaleEffect(self.isAnimating ? 1.35 : 0)
                            .animation(Animation.easeIn(duration: animationDuration))
                            .opacity(self.isAnimating ? 0 : 1)
                            .animation(Animation.easeIn(duration: animationDuration).delay(animationDuration))
                    )
            }.frame(width: 250, height: 250)
            .scaleEffect(self.shrinkIcon ? 0.35 : 1)
            .animation(Animation.spring(response: animationDuration, dampingFraction: 1, blendDuration: 1))
            if (floatLike) {
                FloatingLike(isAnimating: $floatLike, likeColor: self.likeColor)
                    .offset(y: -40)
            }
        }.onTapGesture {
            if (!floatLike) {
                viewModel.is_lucky = isLucky
                viewModel.writeData(context: viewContext)
                self.floatLike.toggle()
                self.isAnimating.toggle()
                self.shrinkIcon.toggle()
                Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
                    self.shrinkIcon.toggle()
                    self.showFlare.toggle()
                }
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false){ _ in
                    self.isAnimating = false
                    self.shrinkIcon = false
                    self.showFlare = false
                    self.floatLike = false
                }
            }
        }
    }
}

struct CapusuleGroupView: View {
    
    // MARK:- variables
    @Binding var isAnimating: Bool
    
    let likeColor: Color
    
    // MARK:- views
    var body: some View {
        ZStack {
            ShrinkingCapsule(rotationAngle: .zero, offset: CGSize(width: 0, height: -15), isAnimating: $isAnimating, likeColor: self.likeColor)
            ShrinkingCapsule(rotationAngle: .degrees(-33), offset: CGSize(width: -80, height: 7.5), isAnimating: $isAnimating, likeColor: self.likeColor)
            ShrinkingCapsule(rotationAngle: .degrees(33), offset: CGSize(width: 80, height: 7.5), isAnimating: $isAnimating, likeColor: self.likeColor)
            ShrinkingCapsule(rotationAngle: .degrees(-65), offset: CGSize(width: -135, height: 70), isAnimating: $isAnimating, likeColor: self.likeColor)
            ShrinkingCapsule(rotationAngle: .degrees(65), offset: CGSize(width: 135, height: 70), isAnimating: $isAnimating, likeColor: self.likeColor)
            LowerCapsuleView(isAnimating: $isAnimating, likeColor: self.likeColor)
        }
        .onTapGesture {
            self.isAnimating.toggle()
        }
    }
}

struct FloatingLike: View {
    
    let animationDuration: TimeInterval = 0.45
    let animation = Animation.spring(response: 0.75).speed(0.75)
    
    @State var scale: CGFloat = 1.25
    @State var offset: CGSize = CGSize(width: 0, height: 0)
    @State var rotationAngle: Angle = Angle.degrees(-4)
    @State var opacity: Double = 1
    
    @Binding var isAnimating: Bool
    
    let likeColor: Color
    
    var body: some View {
        ZStack{
            Capsule(style: .circular)
                .fill(likeColor)
            HStack {
                Spacer()
                Image(systemName: "plus")
                    .foregroundColor(Color.white)
                    .font(.system(size: 52, weight: .bold, design: .monospaced))
                Text("1")
                    .foregroundColor(.white)
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                Spacer()
            }
        }.frame(width: 165, height: 130, alignment: .center)
        .rotationEffect(rotationAngle)
        .scaleEffect(scale)
        .offset(offset)
        .opacity(opacity)
        .onAppear() {
            self.scale = 0.1
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { checkingTimer in
                if (isAnimating) {
                    checkingTimer.invalidate()
                    floatCapsule()
                }
            }
        }
    }
    
    // MARK:- functions
    func floatCapsule() {
        withAnimation(animation) {
            self.scale = 0.75
            self.offset = CGSize(width: 10, height: -100)
            self.rotationAngle = .degrees(-10)
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) { _ in
            withAnimation(animation) {
                self.offset = CGSize(width: -10, height: -200)
            }
            withAnimation(Animation.spring(response: animationDuration * 1.2).speed(0.75)) {
                self.rotationAngle = .degrees(10)
            }
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration , repeats: false) { _ in
            withAnimation(animation) {
                self.offset = CGSize(width: 0, height: -300)
                self.rotationAngle = .degrees(0)
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.5, repeats: false) { _ in
            withAnimation(animation) {
                self.opacity = 0
            }
        }
    }
}

struct HeartImageView: View {
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(.system(size: 160, weight: .medium, design: .monospaced))
    }
}

struct LowerCapsuleView: View {
    
    // MARK:- variables
    @Binding var isAnimating: Bool
    
    let likeColor: Color
    
    // MARK:- views
    var body: some View {
        ZStack {
            ShrinkingCapsule(rotationAngle: .degrees(16), offset: CGSize(width: -42.5, height: 10), isAnimating: $isAnimating, likeColor: self.likeColor)
            ShrinkingCapsule(rotationAngle: .degrees( -16), offset: CGSize(width: 42.5, height: 10), isAnimating: $isAnimating, likeColor: self.likeColor)
            ShrinkingCapsule(rotationAngle: .degrees(48), offset: CGSize(width: -107, height: -30), isAnimating: $isAnimating, likeColor: self.likeColor)
            ShrinkingCapsule(rotationAngle: .degrees(-48), offset: CGSize(width: 107, height: -30), isAnimating: $isAnimating, likeColor: self.likeColor)
            ShrinkingCapsule(rotationAngle: .degrees(82), offset: CGSize(width: -142, height: -95), isAnimating: $isAnimating, likeColor: self.likeColor)
            ShrinkingCapsule(rotationAngle: .degrees(-82), offset: CGSize(width: 142, height: -95), isAnimating: $isAnimating, likeColor: self.likeColor)
        }
        .offset(y: 260)
    }
}

struct ShrinkingCapsule: View {
    
    // MARK:- variables
    let animationDuration: Double = 0.4
    let rotationAngle: Angle
    let offset: CGSize
    
    @Binding var isAnimating: Bool
    @State var hideCapsule: Bool = false
    
    let likeColor: Color
    
    var body: some View {
        ZStack {
        Capsule(style: .continuous)
            .fill(likeColor)
            .frame(width: 15, height: self.isAnimating ? 30 : 65, alignment: .bottomLeading)
            .rotationEffect(rotationAngle)
        }.offset(offset)
        .opacity(self.hideCapsule ? 0 : 0.8)
        .animation(Animation.easeIn(duration: animationDuration))
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if (self.isAnimating) {
                    Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
                        self.hideCapsule.toggle()
                    }
                    timer.invalidate()
                }
            }
        }
    }
}



struct LikeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LikeView(viewModel: ViewModel(), likeColor: .pink, likeOverlay: .black, likeBackground: .purple, isLucky: true)
    }
}
