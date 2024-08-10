//
//  OnboardingWeek.swift
//  LevelMax
//
//  Created by 이승현 on 8/10/24.
//

import SwiftUI

struct OnboardingWeek: View {
    @EnvironmentObject var dataModel: SharedDataModel
    @State var isPickerVisible: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                VStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Gestational Age")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Color("온보딩 버튼"))
                        Text("How far along are you?")
                            .padding(.top, 5)
                            .foregroundStyle(Color("온보딩 버튼"))
                        HStack {
                            Text(String(format: "%02d", dataModel.selectedWeek))
                                .font(.system(size: 60, weight: .bold))
                                .foregroundStyle(Color("온보딩 버튼"))
                                .onTapGesture {
                                    withAnimation {
                                        isPickerVisible.toggle()
                                    }
                                }
                            Text("Weeks")
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
                Picker("Select Week", selection: $dataModel.selectedWeek) {
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
            NavigationLink(destination: OnboardingLottie(selectedWeek: dataModel.selectedWeek)) {
                Text("Complete")
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

//#Preview {
//    //OnboardingWeek(selectedWeek: selectedWeek.selectedWeek)
//}

