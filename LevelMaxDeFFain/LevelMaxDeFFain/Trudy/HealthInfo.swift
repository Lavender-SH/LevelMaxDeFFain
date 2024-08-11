import HealthKit
import SwiftUI

class HealthInfo {
    let healthStore = HKHealthStore()
    let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
    let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])

    func requestAuthorization() {
        self.healthStore.requestAuthorization(toShare: share, read: read) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if success {
                    print("권한 허가")
                } else {
                    print("권한 불허")
                }
            }
        }
    }

    func getHeartRateData(completion: @escaping ([HKSample]) -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }

        let startDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        // NSSortDescriptor 사용
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (_, result, error) in
            
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                return
            }
            guard let resultDate = result else {
                print("load result fail")
                return
            }
            DispatchQueue.main.async {
                completion(resultDate)
            }
        }
        healthStore.execute(query)
    }
}
