//
//  CalorieTableViewCell.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2022/01/15.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {

    @IBOutlet weak var consumCalory: UILabel!
    @IBOutlet weak var walkCount: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var targetlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        progressBar.progressTintColor = .green
        progressBar.tintColor = .lightGray
    }
    
    //　セルの値を設定する
    func setObject(consum:Double,stepCount:Int,target:Int){
        consumCalory.text = String(consum) + "kCal"
        walkCount.text = String(stepCount) + "歩"
        targetlabel.text = String(target)
        progressBar.setProgress(calcProgress(target: target, now: stepCount), animated: true)
    }
    
    // 歩数目標の進捗を計算
    private func calcProgress(target:Int,now:Int) -> Float{
        if now == 0 {
            // 歩数が0の場合
            return 0.0
        }
        
        return 1.0 - Float(target/now)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
