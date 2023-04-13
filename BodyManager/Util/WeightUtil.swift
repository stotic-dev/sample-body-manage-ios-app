//
//  WeightUtil.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2021/12/05.
//

import Foundation
import Firebase

protocol WeightUtilDelegate {
    func getUserInfo(userInfos:[UserInfo])
    func getInsertError(error:Error)
}

class WeightUtil {
    
    init(uid:String) {
        self.db = db.document(uid).collection("info")
    }
    
    var db = Firestore.firestore().collection("userInfo")
    var delegate:WeightUtilDelegate!
    
    public func selectAllUserInfo(){
        db.addSnapshotListener({ snapshots, error in
            if let error = error{
                print("chartの情報の取得に失敗しました\(error)")
                return
            }
            
            var infoArray = [UserInfo]()
            guard let documents = snapshots?.documents else { return }
            documents.forEach { doc in
                let data = doc.data()
                let userInfo = UserInfo(userId: "", userName: "", height: 0, weight: data["weight"] as! Double, date: data["createdAt"] as! Timestamp)
                infoArray.append(userInfo)
            }
            
            self.delegate.getUserInfo(userInfos: infoArray)
        }
        )
        
    }
    
    
    public func insertUserWeight(weight:Double){
        guard let dic = ["weight":weight,"createdAt":Timestamp(date: Date())] as? [String:Any] else { return }
        db.document().setData(dic) { error in
            if let error = error{
                print("faild insert data at insertUserWeight")
                self.delegate.getInsertError(error: error)
                return
            }
            
            print("sucess insert data at insertUserWeight")
        }
    }
}
