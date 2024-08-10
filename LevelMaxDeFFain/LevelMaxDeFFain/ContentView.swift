//
//  ContentView.swift
//  LevelMax
//
//  Created by 이승현 on 8/10/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataModel: SharedDataModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("DeFFein")
                    .font(.title2.bold())
                Spacer()

                NavigationLink(destination: OnboardingWeek()) {
                    Text("Start")
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
        }
    }
}

#Preview {
    ContentView()
}

