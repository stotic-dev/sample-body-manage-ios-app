//
//  AddContentsViewController.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2021/12/21.
//

import UIKit
import ViewAnimator

class AddContentsViewController: UIViewController {
    
    @IBOutlet weak var tabItemButton: UITabBarItem!
    
    var addFlag:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let flag = addFlag else { return }
        
        if flag {
            let chartViewController = self.tabBarController?.viewControllers?[0] as! ChartViewController
            chartViewController.loadFlag = true
            self.addFlag = false
        }
    }
    
    @IBAction func weightAddAction(_ sender: Any) {
        self.performSegue(withIdentifier: "addWeightSegue", sender: nil)
    }
    
}
