//
//  ProfileView.swift
//  LevelMaxDeFFain
//
//  Created by hanseoyoung on 8/11/24.
//

import SwiftUI
import Charts

struct ProfileView: View {
    var body: some View {
        VStack() {
            HStack(spacing: 10) {
                ZStack() {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                    VStack() {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Super MOM")
                            .font(.system(size: 20, weight: .bold))

                    }
                }

                ZStack() {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))

                    Text("HR AVG \n78BPM")
                        .font(.system(size: 20, weight: .bold))
                }

            }

            ZStack() {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))

                Chart(sampleData) { entry in
                    LineMark(
                        x: .value("Date", entry.date),
                        y: .value("Heart Rate", entry.heartRate)
                    )
                    .foregroundStyle(.red)
                    .lineStyle(StrokeStyle(lineWidth: 2))

                    BarMark(
                        x: .value("Date", entry.date),
                        y: .value("Caffeine Intake", entry.caffeineIntake)
                    )
                    .foregroundStyle(.my581919)
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 5))
                    AxisMarks(position: .trailing, values: .automatic(desiredCount: 5))
                }
                .chartForegroundStyleScale([
                            "Heart Rate": .blue,
                            "Caffeine Intake": .my581919
                ])
                .chartLegend(position: .top, alignment: .center) {
                    HStack {
                        Text("Heart Rate").foregroundColor(.my581919)
                        Spacer()
                        Text("Caffeine Intake").foregroundColor(.red)
                    }
                }
                .padding()

            }
            ZStack() {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                Text("The average heart rate is high at 78bpm recently. Caffeine intake is recommended to be 100mg or less.")
                    .font(.system(size: 20, weight: .bold))
                    .padding(5)

            }
            .frame(height: 150)
        }
        .padding(10)
        .background(.myF9F7F2)

    }

}


#Preview {
    ProfileView()
}

struct HealthData: Identifiable {
    let id = UUID()
    let date: Date
    let heartRate: Int
    let caffeineIntake: Int
}


let sampleData: [HealthData] = [
    HealthData(date: Date().addingTimeInterval(-6*24*60*60), heartRate: 66, caffeineIntake: 100),
    HealthData(date: Date().addingTimeInterval(-5*24*60*60), heartRate: 65, caffeineIntake: 80),
    HealthData(date: Date().addingTimeInterval(-4*24*60*60), heartRate: 68, caffeineIntake: 90),
    HealthData(date: Date().addingTimeInterval(-3*24*60*60), heartRate: 77, caffeineIntake: 140),
    HealthData(date: Date().addingTimeInterval(-2*24*60*60), heartRate: 78, caffeineIntake: 144),
    HealthData(date: Date().addingTimeInterval(-1*24*60*60), heartRate: 80, caffeineIntake: 200),
    HealthData(date: Date(), heartRate: 100, caffeineIntake: 200)
]
