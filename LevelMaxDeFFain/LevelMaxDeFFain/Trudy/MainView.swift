import SwiftUI

struct MainView: View {
    @State var percent = 50.0  // 슬라이더 값 퍼센트 저장
    @State var weeks: Int // 임신 주차
    @State var injestedCaffeine: Int = 0 // 섭취한 카페인

    var body: some View {
        VStack {
            HStack{
                Spacer()
                Text("임신 \(weeks)주차")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 17))
                    .padding(.bottom, 30)
                    .padding(.trailing)
                    .fontWeight(.semibold)
                
            }
            Text("오늘의 카페인 섭취")
                .foregroundStyle(Color.black)
                .font(.system(size: 17))
            HStack(alignment: .bottom) {
                Text("\(injestedCaffeine)")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 45))
                Text("/ 200mg")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 14))
                    .padding(.bottom, 12)
            }
            
            // 웨이브 애니메이션을 가운데에 위치시킴
            RoundedRectangleWaveView(percent: Int(self.percent))
                .frame(width: 200, height: 150) // 프레임 크기 조정
                .padding(.vertical, 20)
                .background(Color.clear) // 배경색을 투명하게 설정하여 중앙 정렬
            //                .alignmentGuide(.center) { d in d[.center] } // 중앙 정렬
                .modifier(CenterModifier()) // 중앙 정렬을 위한 커스텀 Modifier 추가
            Button(action: {
                print("기록되어써염")
                //받은 카페인 함량/200 만큼의 비율이 증가되도록 해야한다.
            }, label: {
                Text("카페인 기록하기")
            })
            .frame(width: 232, height: 55)
            .foregroundStyle(Color.black)
            .background(Color.blue.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            // 퍼센트 조정 가능한 슬라이더 조정
            Slider(value: self.$percent, in: 0...100)
                .padding(.horizontal, 20)
        }
        .padding()
        .preferredColorScheme(.light)
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
    let percent: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 150.0)
                .fill(Color.clear) // 배경색 투명
                .overlay(
                    Wave(
                        offset: Angle(degrees: self.waveOffset.degrees),
                        percent: Double(percent) / 100
                    )
                    .fill(waveColor(for: percent))
                    .clipShape(.rect(bottomLeadingRadius: 58, bottomTrailingRadius: 58))
                )
                .frame(width: 116, height: 90) // 프레임 크기를 설정
            //연한 원
            RoundedRectangle(cornerRadius: 150.0)
                .fill(Color.clear) // 배경색 투명
                .overlay(
                    Wave(
                        offset: Angle(degrees: self.waveOffset.degrees),
                        percent: Double(percent) / 100
                    )
                    .fill(waveColor(for: percent).opacity(0.5))
                    .clipShape(.rect(bottomLeadingRadius: 58, bottomTrailingRadius: 58))
                )
                .frame(width: 116, height: 90) // 프레임 크기를 설정
                .padding(.bottom, 15)
            Image("cup")
                .resizable()
                .frame(width: 150, height: 100)
                .padding(.leading, 24)
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
        case 1..<33:
            return Color.my00B3FF
        case 33..<66:
            return Color.myFFEA30
        case 66...100:
            return Color.myF24E4E
        default:
            return Color.clear // 기본값
        }
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
