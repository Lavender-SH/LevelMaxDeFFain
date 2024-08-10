//
//  OnboardingWeek.swift
//  LevelMax
//
//  Created by 이승현 on 8/10/24.
//

import SwiftUI

struct OnboardingWeek: View {
    @State private var selectedWeek: Int = 9
    @State private var isPickerVisible: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("임신 주수")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Color("온보딩 버튼"))
                        Text("현재 임신 몇 주 차이신가요?")
                            .padding(.top, 5)
                            .foregroundStyle(Color("온보딩 버튼"))
                        HStack {
                            Text(String(format: "%02d", selectedWeek))
                                .font(.system(size: 60, weight: .bold))
                                .foregroundStyle(Color("온보딩 버튼"))
                                .onTapGesture {
                                    withAnimation {
                                        isPickerVisible.toggle()
                                    }
                                }
                            Text("주차")
                                .padding(.top, 25)
                                .foregroundStyle(Color("온보딩 버튼"))
                        }
                    }
                    .padding(.leading, 40)
                    //.border(Color("온보딩 버튼"), width: 3)
                }
                Spacer()
            }
            
            // Picker가 선택된 상태일 때만 표시
            if isPickerVisible {
                Picker("Select Week", selection: $selectedWeek) {
                    ForEach(1..<41) { week in
                        Text("\(week)").tag(week)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                //.labelsHidden()
                .frame(height: 150)
                .transition(.slide)
            }
            
            Spacer()
            NavigationLink(destination: OnboardingLottie()) {
                Text("입력 완료")
                    .padding()
                    .font(.system(size: 20).bold())
                    .frame(width: 300, height: 50)
                    .foregroundColor(.white)
                    .background(Color("온보딩 버튼"))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding()
            }
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    OnboardingWeek()
}

