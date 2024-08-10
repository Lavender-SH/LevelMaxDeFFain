//
//  OnboardingLottie.swift
//  LevelMax
//
//  Created by 이승현 on 8/10/24.
//

import SwiftUI

struct OnboardingLottie: View {
    @State private var isActive = false
    var selectedWeek: Int
    
    var body: some View {
        VStack {
            Spacer()
            LottieAnimationViewRepresentable()
                .frame(width: 300, height: 300) // Adjusted height for better visibility
            Text("임산부의 하루 카페인 섭취 권장량은\n200mg입니다.")
                .font(.system(size: 17))
                .padding(.top, 20)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
                    MainView(weeks: selectedWeek, injestedCaffeine: 0)
                }
    }
}

//struct HomeView: View {
//    var body: some View {
//        Text("Welcome to Home!")
//    }
//}

// Preview
struct OnboardingLottie_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingLottie(selectedWeek: 9)

    }
}


