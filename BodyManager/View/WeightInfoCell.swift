//
//  WeightInfoCell.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2022/01/09.
//

import UIKit

class WeightInfoCell: UITableViewCell {
    
    @IBOutlet weak var contentName: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var progressImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setObject(content:String, index:Int){
        self.contentName.text = content
        var valueData:Double!
        var image:UIImage?
        var unit:String!
        
        switch index{
        case 0:
            // 現在の体重の表示と前回記録した体重から増えただどうかの画像を表示
            guard let weightList:[WeightModel]? = UserDefaults.standard.codable(forKey: "weightList") else { return }
            valueData = UserDefaults.standard.value(forKey: "weight") as! Double
            
            if weightList!.count <= 1 {
                // 体重記録のリストが1件以下の場合
                image = UIImage(named: "stay")
                
            }else{
                // 体重記録のリストが2件以上の場合

                let beforeWeight = weightList?[weightList!.count - 2].weight
                
                if valueData < beforeWeight! {
                    image = UIImage(named: "dec")
                }else if valueData == beforeWeight{
                    image = UIImage(named: "stay")
                }else{
                    image = UIImage(named: "inc")
                }
            }
            
            unit = "kg"
            break
        case 1:
            // 現在の身長を表示
            valueData = UserDefaults.standard.value(forKey: "height") as! Double
            
            unit = "cm"
            break
        case 2:
            // 現在のBMIを表示
            let weight = UserDefaults.standard.value(forKey: "weight") as! Double
            let height = UserDefaults.standard.value(forKey: "height") as! Double
            valueData = (weight / (height * height)) * 100
            valueData = round(valueData) / 100
            
            unit = "%"
            break
        case 3:
            // 現在の適正体重を表示
            let height = UserDefaults.standard.value(forKey: "height") as! Double
            valueData = height * height * 22
            
            unit = "kg"
            break
        default:
            break
        }
        
        // 画像を設定
        if image != nil{
            progressImage.image = image
        }
        
        // 設定項目の値を設定
        value.text = String(valueData)+unit
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
