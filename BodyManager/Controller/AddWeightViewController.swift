//
//  AddWeightViewController.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2021/12/21.
//

import UIKit

class AddWeightViewController: UIViewController {

    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightTextField.delegate = self
        addButton.isEnabled = false
        addButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        
    }
    
    @objc private func tappedAddButton(){
        guard let weight = Double(weightTextField.text!) else { return }
        
        // アプリに登録されている体重リストを更新する
        var weightList:[WeightModel]? = UserDefaults.standard.codable(forKey: "weightList")
        let addWeightModel = WeightModel(weight: weight, date: Date())
        weightList?.append(addWeightModel)
        UserDefaults.standard.setCodable(weightList, forKey: "weightList")
        
        // アプリに登録されている最新の体重を更新する
        UserDefaults.standard.setValue(weight, forKey: "weight")
        
        // ChartViewControllerのloadFlagをtrueに更新する
        let tabController = self.presentingViewController as! UITabBarController
        let addContentsViewController = tabController.viewControllers?[1] as! AddContentsViewController
        addContentsViewController.addFlag = true
        
        // 前の画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension AddWeightViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let weight = weightTextField.text else {
            AlertUtil.errorAlert(body: "体重を入力してください。")
            return
        }
        
        let convertUtil = ConvertUtil()
        if(convertUtil.checkStringIsNumber(checkString: weight) != ""){
            addButton.isEnabled = true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weightTextField.resignFirstResponder()
        return false
    }
}
