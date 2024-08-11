import SwiftUI

struct MainView: View {
    @EnvironmentObject var caffeineModel: SharedDataModel
    @EnvironmentObject var sharedData: SharedDataModel
    @State var percent = 50.0  // 슬라이더 값 퍼센트 저장
    @State var weeks: Int // 임신 주차
    @State var injestedCaffeine: Int = 0 // 섭취한 카페인
    let comments = ["Did you have caffeine today?", "You've had a little caffeine", "Little careful!\nIt's already half full", "It's Dangerous!\nYou're getting closer to recommended intake!"]
    
    @State private var isFlipped = false // flip 상태
    @State private var timerValue: TimeInterval = 5 * 3600 // 5시간 (초 단위)
    @State private var isTimerRunning = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 카페인 섭취량에 따라 원의 색과 채워지는 정도를 결정하는 CircleView
                CircleView(injestedCaffeine: $caffeineModel.ingestedCaffeine)
                    .frame(width: 300, height: 300)
                    .padding(.bottom, 40)
                
                VStack {
                    HStack(){
                        NavigationLink(destination: HealthRateView(), label: {
                            Image(systemName: "chart.bar.xaxis.ascending")
                                .resizable()
                                .frame(width: 25, height: 20)
                                .foregroundStyle(Color.my581919)
                                .padding(.bottom, 20)
                                .padding(.leading, 10)
                        })
                        Spacer()
                        Text("\(sharedData.selectedWeek) Weeks")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 17))
                            .padding(.bottom, 30)
                            .padding(.trailing)
                            .fontWeight(.semibold)
                        
                    }
                    Text("Today's caffeine inatake(mg)")
                        .foregroundStyle(Color.black)
                        .font(.system(size: 17))
                    
                    HStack(alignment: .bottom) {
                        Text("\(caffeineModel.ingestedCaffeine)")
                            .foregroundStyle(Color("수치"))
                            .font(.system(size: 45).bold())
                        Text("/ 200mg")
                            .foregroundStyle(Color.black)
                            .font(.system(size: 14))
                            .padding(.bottom, 12)
                    }
                    
                    // 웨이브 애니메이션을 가운데에 위치시킴
                    RoundedRectangleWaveView(percent: $caffeineModel.ingestedCaffeine, isFlipped: $isFlipped, timerValue: $timerValue, isTimerRunning: $isTimerRunning)
                        .frame(width: 200, height: 150) // 프레임 크기 조정
                        .padding(.vertical, 20)
                        .background(Color.clear) // 배경색을 투명하게 설정하여 중앙 정렬
                    //                .alignmentGuide(.center) { d in d[.center] } // 중앙 정렬
                        .modifier(CenterModifier()) // 중앙 정렬을 위한 커스텀 Modifier 추가
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                isFlipped.toggle()
                            }
                            if isFlipped && !isTimerRunning {
                                startTimer()
                            }
                        }
                    
                    Text(determineComment(for: injestedCaffeine))
                        .foregroundColor(Color("온보딩 버튼"))
                        .font(.system(size: 17))
                        .padding(.bottom, 30)
                    
                    NavigationLink(destination: MenuListView()) {
                        Text("Recording Caffeine")
                            .padding()
                            .font(.system(size: 20).bold())
                            .frame(width: 300, height: 50)
                            .foregroundColor(.white)
                            .background(Color("온보딩 버튼"))
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .padding()
                    }
                    
                    // 퍼센트 조정 가능한 슬라이더 조정
//                    Slider(value: self.$percent, in: 0...100)
//                        .padding(.horizontal, 20)
                    
                }
                .padding()
                .preferredColorScheme(.light)
            }
        }
    }
    
    private func startTimer() {
        isTimerRunning = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timerValue > 0 {
                timerValue -= 1
            } else {
                timer.invalidate()
                isTimerRunning = false
            }
        }
    }
    
    private func determineComment(for caffeineAmount: Int) -> String {
        if caffeineAmount == 0 {
            return comments[0]
        } else if caffeineAmount < 100 {
            return comments[1]
        } else if caffeineAmount < 150 {
            return comments[2]
        } else {
            return comments[3]
        }
    }
}

struct Wave: Shape {
    // 웨이브 애니메이션을 위한 오프셋 각도 및 퍼센트 값
    var offset: Angle
    var percent: Double
    
    // offset 각도 설정
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }
    
    // 주어진 CGRect 내에 웨이브 경로 그림
    func path(in rect: CGRect) -> Path {
        var point = Path()
        
        // 웨이브 시작과 끝을 위한 보정값
        let lowfudge = 0.02
        let highfudge = 0.98
        
        // 퍼센트 값을 높이에 맞게 보정
        let newpercent = lowfudge + (highfudge - lowfudge) * percent
        let waveHeight = 0.03 * rect.height
        let yoffset = CGFloat(1 - newpercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        
        // 웨이브가 시작하고 끝나는 각도 설정
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)
        
        // 웨이브의 첫 번째 점을 설정
        point.move(to: CGPoint(x: 0, y: yoffset + waveHeight * CGFloat(sin(offset.radians))))
        
        // 웨이브 경로 생성
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees - 0.0001, by: 1) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            point.addLine(to: CGPoint(x: x, y: yoffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        // 웨이브 아래 영역 채우기 위한 경로 추가
        point.addLine(to: CGPoint(x: rect.width, y: rect.height))
        point.addLine(to: CGPoint(x: 0, y: rect.height))
        point.closeSubpath() // 경로 닫아서 완성
        
        return point
    }
}

struct RoundedRectangleWaveView: View {
    
    @State private var waveOffset = Angle(degrees: 0)
    @Binding var percent: Int
    @Binding var isFlipped: Bool
    @Binding var timerValue: TimeInterval
    @Binding var isTimerRunning: Bool
    
    var body: some View {
        ZStack {
            if isFlipped {
                VStack {
                    Text("Caffeine\nTime required to export")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 17))
                        .padding(.bottom, 10)
                    Text(timeString(from: timerValue))
                        .font(.system(size: 34).bold())
                        .foregroundColor(Color("타이머색"))
                        .transition(.flip)
                    Spacer()
                }
            } else {
                RoundedRectangle(cornerRadius: 150.0)
                    .fill(Color.clear)
                    .overlay(
                        Wave(
                            offset: Angle(degrees: self.waveOffset.degrees),
                            percent: Double(percent) / 200
                        )
                        .fill(waveColor(for: percent))
                        .clipShape(.rect(bottomLeadingRadius: 58, bottomTrailingRadius: 58))
                    )
                    .frame(width: 116, height: 90)
                    .transition(.flip)
                
                RoundedRectangle(cornerRadius: 150.0)
                    .fill(Color.clear)
                    .overlay(
                        Wave(
                            offset: Angle(degrees: self.waveOffset.degrees),
                            percent: Double(percent) / 200
                        )
                        .fill(waveColor(for: percent).opacity(0.5))
                        .clipShape(.rect(bottomLeadingRadius: 58, bottomTrailingRadius: 58))
                    )
                    .frame(width: 116, height: 90)
                    .padding(.bottom, 15)
                
                Image("cup")
                    .resizable()
                    .frame(width: 150, height: 100)
                    .padding(.leading, 24)
            }
        }
        .aspectRatio(contentMode: .fit)
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                self.waveOffset = Angle(degrees: 360)
            }
        }
    }
    
    // 퍼센테이지에 따라 색이 달라지도록 설정
    private func waveColor(for percent: Int) -> Color {
        switch percent {
        case 1..<66:
            return Color.my00B3FF
        case 66..<132:
            return Color.myFFEA30
        case 132...200:
            return Color.myF24E4E
        default:
            return Color.myF24E4E // 기본값
        }
    }
    private func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension AnyTransition {
    static var flip: AnyTransition {
        AnyTransition.asymmetric(
            insertion: AnyTransition.scale.combined(with: .opacity),
            removal: AnyTransition.scale.combined(with: .opacity)
        )
    }
}



// 중앙 정렬을 위한 커스텀 Modifier
struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: CenterPreferenceKey.self, value: geometry.size)
            })
            .onPreferenceChange(CenterPreferenceKey.self) { size in
                // 추가적인 작업이 필요하면 여기에 작성
            }
    }
}

struct CircleView: View {
    @Binding var injestedCaffeine: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 30)
                //.shadow(color: .gray.opacity(0.6), radius: 20, y: 8)
            
            Circle()
                .trim(from: 0, to: min(CGFloat(injestedCaffeine) / 200, 1.0))
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.brown, Color("온보딩 버튼")]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1), value: injestedCaffeine)
        }
    }
}


struct CenterPreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

struct WaveAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(weeks: 3, injestedCaffeine: 5)
    }
}
