//
//  FirstViewController.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2021/11/12.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var registButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        registButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        
        registButton.isEnabled = false
    }
    
    @objc private func tappedButton(){
        guard let userName = textView.text else { return }
        UserDefaults.standard.setValue(userName, forKey: "userName")
        performSegue(withIdentifier: "registSegue_01", sender: nil)
    }
    
}

extension FirstViewController:UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textView.text != nil {
            registButton.isEnabled = true
        }else{
            registButton.isEnabled = false
        }
    }
}
