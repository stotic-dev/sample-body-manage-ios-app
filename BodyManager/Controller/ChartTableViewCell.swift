//
//  ChartTableViewCell.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2022/03/21.
//

import UIKit
import Charts

class ChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chartView: LineChartView!
    var chartDataSet:LineChartDataSet!
    var chartViewController:ChartViewController!
    var view:UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayChart(){
        chartViewController = (superview as! UITableView).delegate as! ChartViewController
        setupChartView()
        loadData(data: selectChartRnage(selectRow: chartViewController.selectRange))
    }
    
    private func setupChartView(){
        // chartViewの設定
        chartView.chartDescription?.enabled = true
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.legend.enabled = false
        chartView.xAxis.labelPosition = .top
        chartView.xAxis.granularityEnabled = true
        chartView.xAxis.labelCount = 4
        chartView.leftAxis.labelCount = 6
        
        chartView.rightAxis.enabled = false
        chartView.animate(xAxisDuration: 1.5)
        chartView.setViewPortOffsets(left: 30, top: 20, right: 30, bottom: 20)
        
        self.addSubview(chartView)
    }
    
    // chartにデータを設定する
    private func loadData(data:[WeightModel]){
        // 体重のデータをロードする
//        guard let weightList: [WeightModel]? = UserDefaults.standard.codable(forKey: "weightList") else { return }
        // ユーザー情報が0件1以下の場合処理を終了する
        if(data.count <= 0){ return }
        
        // Y軸の下限と上限を設定
        setYaxisRange(weightList: data)
        
        let data = data.sorted { a, b in
            return a.date < b.date
        }
        
        let dataEntries = data.enumerated().map {ChartDataEntry(x: Double($0), y: $1.weight)}
        
        var days:[String] = []
        data.forEach { model in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            days.append(dateFormatter.string(from: model.date))
        }
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        
        chartDataSet = LineChartDataSet(entries: dataEntries)
        
        chartDataSet.mode = .cubicBezier
        chartDataSet.lineWidth = 5.0
        
        chartView.data = LineChartData(dataSet: chartDataSet)
    }
    
    @IBAction func selectRange(_ sender: Any) {
        // pickerViewで
        chartViewController.setupPickerView()
        
    }
    
    private func selectChartRnage(selectRow:Int) -> [WeightModel]{
        var selectWeightList:[WeightModel]?
        var selectDay:Date!
        
        switch selectRow {
        case 0:
            // 1週間分のリストを設定する
            selectDay = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            break
        case 1:
            // 1ヶ月分のリストを設定する
            selectDay = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            break
        case 2:
            // 3ヶ月分のリストを設定する
            selectDay = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
            break
        case 3:
            // 1年間分のリストを設定する
            selectDay = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
            break
        default:
            // 何もしない
            break
        }
        
        // 設定した期間分をselectWeightListに入れる
        if selectDay != nil{
            let weightList: [WeightModel]? = UserDefaults.standard.codable(forKey: "weightList")
            selectWeightList = weightList?.filter({ model in model.date >= selectDay })
        }else{
            selectWeightList = UserDefaults.standard.codable(forKey: "weightList")
        }
        
        return selectWeightList!
    }
    
    // グラフのY軸の最大値と最小値の範囲を設定する
    private func setYaxisRange(weightList:[WeightModel]){
        let sortedList = weightList.sorted{$0.weight<$1.weight}
        let minWeight = sortedList[0].weight
        let maxWeight = sortedList[weightList.count-1].weight
        
        chartView.leftAxis.axisMinimum = minWeight - 1
        chartView.leftAxis.axisMaximum = maxWeight + 1
    }
    
}
