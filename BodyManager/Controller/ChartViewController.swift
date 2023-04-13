//
//  ChartViewController.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2021/11/28.
//

import UIKit
import Charts
import HealthKit

class ChartViewController: UIViewController {

    @IBOutlet weak var selectRangeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var loadFlag:Bool?
    var visualEffectView = UIVisualEffectView()
    var refleshCon:UIRefreshControl!
    
    var selectRange:Int = 1 {
        didSet{
            tableView.reloadData()
        }
    }
    
    // 現在の歩数を保持
    var stepCount:Double?
    // 現在の運動時間を保持
    var execiseTime:Double?
    // 運動距離を保持
    var distanceWalkingRunning:Double?
    
    // pickerViewの選択肢
    let dataList = ["1週間","1ヶ月","3ヶ月","1年間","全体"]
    // tableViewの項目
    let tableList = ["現在の体重","現在の身長","現在のBMI","適正体重"]
    // sectionのタイトル
    let sectionTitle = ["体重管理","プログレス","基本情報"]
    
    // HealthUtilの初期化
    let healthUtil = HealthUtil()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // HealthUtilのデリゲートを設定
        healthUtil.delegata = self
        
        // リフレッシュ処理の設定
        refleshCon = UIRefreshControl()
        refleshCon.attributedTitle = NSAttributedString(string: "再読み込み中")
        refleshCon.addTarget(self, action: #selector(reflesh), for: .valueChanged)
        tableView.addSubview(refleshCon)
        
        // tableViewの設定
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WeightInfoCell", bundle: nil), forCellReuseIdentifier: "WeightInfoCell")
        tableView.register(UINib(nibName: "calorieTableViewCell", bundle: nil), forCellReuseIdentifier: "calorieTableViewCell")
        tableView.register(UINib(nibName: "ChartTableViewCell", bundle: nil), forCellReuseIdentifier: "chartTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
        
        // healthデータの取得処理
        loadHealthData()
    }
    
    // リフレッシュ処理
    @objc private func reflesh(){
        DispatchQueue.main.async {
            // データ更新
            self.loadHealthData()
        }
        
        refleshCon.endRefreshing()
        
    }
    
    // ヘルスデータの取得処理
    private func loadHealthData(){
        healthUtil.getStepCount()
        healthUtil.getExerciseTime()
        healthUtil.getDistance()
    }
    
    // pickerViewを設定する
    func setupPickerView(){
        
        let pickerView = UIPickerView()
        // pickerViewの表示場所を設定
        pickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2.5)
        pickerView.backgroundColor = .lightGray
        pickerView.center = self.view.center
        pickerView.layer.zPosition = 1000
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        // 背景色をぼかす処理を追加
        let blurEffect = UIBlurEffect(style: .dark)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        visualEffectView.frame = view.frame
        visualEffectView.layer.zPosition = 100
        
        view.addSubview(visualEffectView)
        view.addSubview(pickerView)
    }
    
}

extension ChartViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectRange = row
        
        // pickerViewとブラーを消す
        visualEffectView.removeFromSuperview()
        pickerView.removeFromSuperview()
    }
}

extension ChartViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return 1
            
        case 2:
            return tableList.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        
        return tableView.estimatedSectionHeaderHeight
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0{
//            return nil
//        }
//
//        return UIView()
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 300
        }else if indexPath.section == 1{
            return 100
        }else{
            return tableView.estimatedRowHeight
        }

    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "chartTableViewCell", for: indexPath) as! ChartTableViewCell
            cell.displayChart()
            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "calorieTableViewCell", for: indexPath) as! CalorieTableViewCell
            let stepCount:Double = stepCount ?? 0
            let execiseTime:Double = execiseTime ?? 0
            cell.setObject(consum: Double(healthUtil.getNowCalorie(stepCount: stepCount, execiseTime: execiseTime)), stepCount: Int(stepCount), target: healthUtil.getConsume())
            cell.selectionStyle = .none
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeightInfoCell", for: indexPath) as! WeightInfoCell
            cell.setObject(content: tableList[indexPath.row], index: indexPath.row)
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
            
        }
    }
}

extension ChartViewController:HealthUtilDelegate{
    func getData(data: Double, type: HKQuantityType) {
        
        if data != -1 {
            switch type{
            case HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning):
                distanceWalkingRunning = data
                break
            case HKSampleType.quantityType(forIdentifier: .stepCount):
                stepCount = data
                break
            case HKSampleType.quantityType(forIdentifier: .appleExerciseTime):
                execiseTime = data
                break
            default:break
            }
        }
        
        // 全てのhealthデータを受け取ったか確認
        if distanceWalkingRunning != nil && stepCount != nil && execiseTime != nil{
            tableView.reloadData()
        }
    }
    
}
