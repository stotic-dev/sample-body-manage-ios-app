//
//  SecondViewController.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2021/11/12.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var heightTextView: UITextField!
    @IBOutlet weak var weightTextView: UITextField!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var barthTextField: UITextView!
    @IBOutlet weak var pickerAreaView: UIView!
    
    var datePickerView: UIDatePicker!
    var sexPickerView: UIPickerView!
    
    var sexString:String?
    
    let sexList = ["0:男性","1:女性"]
    
    let notEnableBtn = UIColor.lightGray
    let enableBtn = UIColor.systemIndigo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sexPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: pickerAreaView.frame.width, height: pickerAreaView.frame.height))
        datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: pickerAreaView.frame.width, height: pickerAreaView.frame.height))
        
        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.locale = Locale(identifier: "ja_JP")
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(getDate))
        toolBar.items = [toolBarBtn]
        barthTextField.inputAccessoryView = toolBar
        
        let sexPickerToolBar = UIToolbar()
        sexPickerToolBar.sizeToFit()
        let sexPickerToolBarBtn = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(getSex))
        sexPickerToolBar.items = [sexPickerToolBarBtn]
        sexTextField.inputAccessoryView = sexPickerToolBar
        
        sexPickerView.delegate = self
        sexPickerView.dataSource = self
        
        heightTextView.delegate = self
        weightTextView.delegate = self
        sexTextField.inputView = sexPickerView
        sexTextField.tintColor = .clear
        barthTextField.delegate = self
        barthTextField.inputView = datePickerView
        barthTextField.isEditable = false
        barthTextField.isSelectable = true
        barthTextField.layer.cornerRadius = 5
        
        // 初期表示ではpickerAreaViewを隠す
        pickerAreaView.isHidden = true
        pickerAreaView.backgroundColor = .none
        
        registButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        registButton.isEnabled = false
        registButton.backgroundColor = notEnableBtn
    }
    
    // ボタンの使用判定処理
    private func judgeEnableBtn(){
        if heightTextView.text != "" && weightTextView.text != "" && sexTextField.text != "" && barthTextField.text != ""{
            registButton.isEnabled = true
            registButton.backgroundColor = enableBtn
        }else{
            registButton.isEnabled = false
            registButton.backgroundColor = notEnableBtn
        }
    }
    
    @objc private func tappedButton(){
        let alertConfirm = UIAlertController(title: "確認", message: "入力した情報で間違い無いですか？", preferredStyle: .alert)
        let yes = UIAlertAction(title: "YES", style: .default) { a in
            // OK選択時の処理
            print("tapped YES")
            
            guard let height:String = self.heightTextView.text,let weight:String = self.weightTextView.text else { return }
            let checkString = ConvertUtil()
            
            let heightCheck = checkString.checkStringIsNumber(checkString: height)
            let weightCheck = checkString.checkStringIsNumber(checkString: weight)
            
            // 入力項目の確認処理
            if UserDefaults.standard.value(forKey: "sex") == nil {
                // 性別が登録されていない場合
                AlertUtil.errorAlert(body: "性別が入力されていません")
                return
            }
            
            if UserDefaults.standard.value(forKey: "age") == nil {
                // 生年月日が登録されていない場合
                AlertUtil.errorAlert(body: "生年月日が入力されていません")
                return
            }
            
            if heightCheck == "" || weightCheck == ""{
                // 身長もしくは体重が不正な値の場合
                AlertUtil.errorAlert(body: "身長と体重のどちらかもしくは両方が不正な値です")
                return
            }
            
            let heightDouble = Double(heightCheck)!
            let weightDouble = Double(weightCheck)!
            
            UserDefaults.standard.setValue(heightDouble, forKey: "height")
            UserDefaults.standard.setValue(weightDouble, forKey: "weight")
            UserDefaults.standard.setValue(UIDevice.current.identifierForVendor?.uuidString, forKey: "userId")
            
            let weightList = [WeightModel(weight: weightDouble, date: Date())]
            UserDefaults.standard.setCodable(weightList, forKey: "weightList")
            
            self.performSegue(withIdentifier: "registSegue_02", sender: nil)
            
        }
        
        let no = UIAlertAction(title: "NO", style: .cancel, handler: { a in
            // NG選択時の処理
            print("tapped NO")
        })
        
        alertConfirm.addAction(yes)
        alertConfirm.addAction(no)
        
        present(alertConfirm, animated: true, completion: nil)
    }
    
    @objc private func getSex(){
        guard let sexCode = sexString?.prefix(1) else { return }
        UserDefaults.standard.setValue(Int(sexCode), forKey: "sex")
        sexTextField.resignFirstResponder()
    }
    
    @objc private func getDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        UserDefaults.standard.setValue(datePickerView.date, forKey: "barthDate")
        
        let age = BarthDayUtil.caluculateAge()
        if age < 0 {
            // 入力された生年月日が未来の場合、エラーアラートを出力して関数の処理を終了する
            AlertUtil.errorAlert(body: "生年月日が不正な値です")
            return
        }
        
        barthTextField.text = dateFormatter.string(from: datePickerView.date)
        
        UserDefaults.standard.setValue(age, forKey: "age")
        
        self.barthTextField.resignFirstResponder()
    }
    
    // 画面がタップされた時の挙動
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heightTextView.resignFirstResponder()
        weightTextView.resignFirstResponder()
        sexTextField.resignFirstResponder()
        barthTextField.resignFirstResponder()
    }
    
}

extension SecondViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        heightTextView.resignFirstResponder()
        weightTextView.resignFirstResponder()
        sexTextField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        judgeEnableBtn()
    }
    
}

extension SecondViewController:UITextViewDelegate{
    func textViewDidChangeSelection(_ textView: UITextView) {
        judgeEnableBtn()
    }
}

extension SecondViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sexList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sexString = sexList[row]
        guard let sexIndex = sexString?.index(sexString!.startIndex, offsetBy: 2, limitedBy: sexString!.endIndex) else { return }
        sexTextField.text = String((sexString?[sexIndex...])!)
    }
    
}

