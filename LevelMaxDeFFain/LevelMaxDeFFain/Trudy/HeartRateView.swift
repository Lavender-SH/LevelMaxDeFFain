import SwiftUI
import HealthKit
import Combine

/// `HealthRateView`는 현재 심박수, 평균 심박수 및 실시간 심박수 그래프를 표시하는 뷰입니다.
struct HealthRateView: View {
    @StateObject var viewModel = HealthRateViewModel() // ViewModel을 상태 객체로 사용
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(systemName: "heart.text.square.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(Color.my581919)
                .padding(.leading)
                .padding(.top)
                .padding(.bottom, 20)
//                .padding(.leading)
            // 최근 1시간 동안의 평균 심박수를 표시
            Text("Average Heart Rate")
                .font(.system(size: 17))
                .foregroundStyle(Color.my581919)
                .padding(.leading)
//                .padding()
            // 최근 1시간 동안의 평균 심박수를 표시
            Text("\(viewModel.averageHeartRate, specifier: "%.1f") bpm")
                .font(.title)
//                .padding()
                .foregroundStyle(Color.my00C286)
                .bold()
                .padding(.leading)
            
            Text("Caffeine intake  is recommended to be")
                .font(.system(size: 17))
                .foregroundStyle(Color.my581919)
                .padding(.leading)
//                .padding()
                .bold()
            // 최근 1시간 동안의 평균 심박수를 표시
            Text("100mg or less")
                .font(.title)
//                .padding()
                .foregroundStyle(Color.my00C286)
                .bold()
                .padding(.bottom)
                .padding(.leading)
            HStack{
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 17, height: 14)
                    .foregroundStyle(Color.my581919)
                    .padding(.leading, 20)
                Spacer()
                
                Image(systemName: "cup.and.saucer.fill")
                    .resizable()
                    .frame(width: 17, height: 14)
                    .foregroundStyle(Color.my581919)
                    .padding(.trailing)
            }
            HStack{
                Text("Heart Rate")
                    .font(.system(size: 17))
                    .foregroundStyle(Color.my581919)
                    .padding(.leading, 20)
                Spacer()
                Text("Caffein Intake")
                    .font(.system(size: 17))
                    .foregroundStyle(Color.my581919)
                    .padding(.trailing)
            }
            .padding(.bottom)
            
            // 막대 그래프 표시 (6개의 막대만 표시)
            BarGraph(dataPoints: Array(viewModel.heartRates.suffix(6)))
                .frame(width: 350, height: 250)
                .padding()
                .padding(.trailing)
                .padding(.bottom, 30)
            Text("Description")
                .font(.system(size: 17))
                .foregroundStyle(Color.my581919)
                .fontWeight(.semibold)
                .padding(.leading, 20)
            Text("The average heart rate is high at \(viewModel.averageHeartRate, specifier: "%.1f")bpm recently. Caffeine intake is recommended to be 100mg or less")
                .font(.system(size: 17))
                .foregroundStyle(Color.my581919)
                .padding(.leading, 20)
            
            
            Spacer()
        }
        .onAppear {
            // 뷰가 나타날 때 데이터 모니터링 시작
            viewModel.startMonitoring()
        }
        .onDisappear {
            // 뷰가 사라질 때 데이터 모니터링 중지
            viewModel.stopMonitoring()
        }
    }
}

struct BarGraph: View {
    var dataPoints: [(Double, Date)] // 그래프에 표시할 데이터 포인트들 (심박수, 시간)
    
    private func yPosition(for value: Double, maxY: Double, height: CGFloat) -> CGFloat {
        return CGFloat(value / maxY) * height
    }
    
    private func timeLabel(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let maxY = (dataPoints.map { $0.0 }.max() ?? 1)
            let totalSpacing = CGFloat(dataPoints.count - 1) * 10.0 // 가로 간격
            let availableWidth = geometry.size.width - totalSpacing
            let barWidth: CGFloat = 16.0
            
            ZStack {
                // 세로축
                VStack {
                    ForEach(0..<5) { i in
                        Spacer()
                        HStack {
                            Text("\(Int(maxY * Double(4 - i) / 4))")
                                .font(.caption)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // 가로축
                HStack(alignment: .bottom, spacing: 37) { // 가로 간격
                    ForEach(dataPoints.indices, id: \.self) { index in
                        let (value, date) = dataPoints[index]
                        let yPosition = yPosition(for: value, maxY: maxY, height: height)
                        VStack {
                            Rectangle()
                                .fill(Color.red)
                                .fill(LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color.myD74C4C, location: 0),
                                        .init(color: Color.my712828, location: 1)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .frame(width: barWidth - 2, height: yPosition)
                                .clipShape(.rect(topLeadingRadius: 20, topTrailingRadius: 20))
                            // 시간 표시
                            Text(timeLabel(for: date))
                                .font(.caption)
                                .offset(y: 10)
                        }
                    }
                }
                .frame(height: height, alignment: .bottomTrailing)
                .padding(.leading, 20)
                .padding(.bottom, -23)
            }
        }
    }
}



import HealthKit
import SwiftUI
import Combine

class HealthRateViewModel: ObservableObject {
    private var healthStore = HKHealthStore()
    private var heartRateSamples = [HKQuantitySample]()
    private var timer: Timer?
    private var observerQuery: HKObserverQuery?
    
    @Published var heartRates = [(Double, Date)]()
    @Published var averageHeartRate: Double = 0.0
    @Published var currentHeartRate: Double?
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { (success, error) in
            if success {
                self.setupObserverQuery()
                self.startMonitoring()
            } else {
                print("HealthKit authorization failed")
            }
        }
    }
    
    func setupObserverQuery() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        
        observerQuery = HKObserverQuery(sampleType: heartRateType, predicate: nil) { [weak self] (query, completionHandler, error) in
            guard error == nil else {
                print("Error setting up observer query: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self?.fetchHeartRateData()
            completionHandler()
        }
        
        if let observerQuery = observerQuery {
            healthStore.execute(observerQuery)
        }
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 3600.0, repeats: true) { [weak self] _ in
            self?.fetchHeartRateData()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        if let observerQuery = observerQuery {
            healthStore.stop(observerQuery)
        }
    }
    
    func fetchHeartRateData() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let startDate = Calendar.current.date(byAdding: .hour, value: -7, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { [weak self] (_, result, error) in
            guard let samples = result as? [HKQuantitySample], error == nil else {
                print("Error fetching heart rate data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self?.heartRateSamples = samples
                self?.updateHeartRates()
            }
        }
        
        healthStore.execute(query)
    }
    
    private func updateHeartRates() {
        DispatchQueue.main.async {
            // 시간별 평균 심박수 계산
            let calendar = Calendar.current
            let now = Date()
            var hourlyData = [Date: [Double]]()
            
            for sample in self.heartRateSamples {
                let date = sample.startDate
                let hourStart = calendar.date(bySettingHour: calendar.component(.hour, from: date), minute: 0, second: 0, of: date)!
                
                if hourlyData[hourStart] == nil {
                    hourlyData[hourStart] = []
                }
                hourlyData[hourStart]?.append(sample.quantity.doubleValue(for: HKUnit(from: "count/min")))
            }
            
            let sortedHours = hourlyData.keys.sorted()
            self.heartRates = sortedHours.map { hour in
                let rates = hourlyData[hour]!
                let averageRate = rates.reduce(0, +) / Double(rates.count)
                return (averageRate, hour)
            }
            
            if let lastSample = self.heartRateSamples.last {
                self.currentHeartRate = lastSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
            
            if !self.heartRates.isEmpty {
                self.averageHeartRate = self.heartRates.map { $0.0 }.reduce(0, +) / Double(self.heartRates.count)
            }
        }
    }
}
