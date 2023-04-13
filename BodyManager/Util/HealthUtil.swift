//
//  HealthUtil.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2022/01/15.
//

import Foundation
import HealthKit

protocol HealthUtilDelegate {
    func getData(data:Double,type:HKQuantityType)
}

class HealthUtil {
    var delegata:HealthUtilDelegate?
    let read = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,HKObjectType.quantityType(forIdentifier: .stepCount)!,HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!)
    let healthstore = HKHealthStore()
    let types = [HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!,HKSampleType.quantityType(forIdentifier: .stepCount)!,HKSampleType.quantityType(forIdentifier: .appleExerciseTime)!]
    
    // 取得ヘルスケアデータ範囲
    var datePredicate = {
        return HKQuery.predicateForSamples(withStart: Calendar(identifier: .gregorian).startOfDay(for: Date()), end: Date())
    }
    
    func authHealthInApp(){
        if !HKHealthStore.isHealthDataAvailable() {
            print("healthkit未対応です")
        }
        
        healthstore.requestAuthorization(toShare: nil, read: read) { status, error in
            if status {
                print("認証OK")
            }else{
                print("認証NG　reason: "+error.debugDescription)
            }
        }
    }
    
    // ヘルスデータを取得する
    func getHealthData(type:HKQuantityType, unit:HKUnit){
        // 取得データの間隔を設定
        let datePredicate = HKQuery.predicateForSamples(withStart: Calendar(identifier: .gregorian).startOfDay(for: Date()), end: Date())
        
        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: datePredicate, options: .separateBySource) { query, data, error in
            if let error = error{
                print("query_1 データの取得に失敗 reason: "+error.localizedDescription)
                return
            }
            
            // healthデータ取得のクエリー実行の際にデリゲーとメソッドを呼び出し(テスト用)
            self.delegata?.getData(data: data?.sumQuantity()?.doubleValue(for: unit) ?? -1, type: type)
            
            // iphoneの情報のみ取得する
            if let souces = data?.sources?.filter({$0.bundleIdentifier.hasPrefix("com.apple.health")}){
                let sourcesPredicate = HKQuery.predicateForObjects(from: Set(souces))
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate,sourcesPredicate])
                let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, statics, error in
                    if let error = error{
                        print("query_2 データの取得に失敗 reason: "+error.localizedDescription)
                        return
                    }
                    
                    // healthデータ取得のクエリー実行の際にデリゲーとメソッドを呼び出し
                    self.delegata?.getData(data: statics?.sumQuantity()?.doubleValue(for: unit) ?? -1, type: type)
                }
                self.healthstore.execute(query)
            }
        }
        healthstore.execute(query)
    }
    
    // 歩数の取得
    func getStepCount(){
        getHealthData(type: types[1], unit: .count())
    }
    
    // 運動時間の取得
    func getExerciseTime(){
        getHealthData(type: types[2], unit: .second())
    }
    
    // 運動距離の取得
    func getDistance(){
        getHealthData(type: types[0], unit: .meter() )
    }
    
    // 本日のウォーキング消費カロリーを取得
    func getNowCalorie(stepCount:Double,execiseTime:Double) -> Double{
        let weight = UserDefaults.standard.value(forKey: "weight") as! Double
        
        // Metsの計算
        var mets = stepCount / execiseTime
        
        if mets >= 130 {
            mets = 6
        }else if mets >= 120{
            mets = 5
        }else if mets >= 110{
            mets = 4
        }else if mets >= 100{
            mets = 3
        }else if mets >= 90{
            mets = 2
        }else{
            mets = 1
        }
        
        return mets * weight * execiseTime * 1.05
        
    }
    
    // 現在の歩数を取得
    func getStepCount(stepCount:Double) -> Int{
        return Int(stepCount)
    }
    
    // 目標歩数を取得
    func getConsume() -> Int{
        // 性別を取得
        let sex = UserDefaults.standard.value(forKey: "sex") as! Int
        // 年齢を取得
        let age = UserDefaults.standard.value(forKey: "age") as! Int
        
        switch sex {
        case 0:
            if age >= 65{
                return 7000
            }else{
                return 9000
            }
        case 1:
            if age >= 65{
                return 6000
            }else{
                return 8500
            }
        default:
            if age >= 65{
                return 6500
            }else{
                return 8750
            }
        }
        
    }
    
}
