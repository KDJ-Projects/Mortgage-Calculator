//
//  SplashScreenView.swift
//  Mortgage-Calculator
//
//  Created by Kurt De Jonghe on 22/12/2022.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.2
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color.red
                    .opacity(0.60)
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        Image(systemName: "house")
                            .font(.system(size: 250))
                            .foregroundColor(.black)
                        
                        Text("Hypotheek Calculator")
                            .font(Font.custom("Baskerville-Bold", size: 26))
                            .foregroundColor(.black.opacity(0.80))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 2.0)) {
                            self.size = 0.9
                            self.opacity = 1.5
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation {
                            self.isActive = true
                        }
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
}
