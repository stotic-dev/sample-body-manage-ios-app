//
//  WeightModel.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2021/12/27.
//

import Foundation

struct WeightModel:Codable{
    var weight:Double
    var date:Date
}

extension Encodable {

    var json: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}

extension Decodable {

    static func decode(json data: Data?) -> Self? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(Self.self, from: data)
    }
}

extension UserDefaults{
    
    func setCodable(_ value:Codable?, forKey key:String){
        guard let json : Any = value?.json else { return }
        self.set(json, forKey: key)
    }
    
    func codable<T: Codable>(forKey key:String) -> T? {
        let data = self.data(forKey: key)
        let object = T.decode(json: data)
        return object
    }
}
