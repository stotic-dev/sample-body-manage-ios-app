//
//  ThirdViewController.swift
//  BodyManager
//
//  Created by 佐藤汰一 on 2021/11/12.
//

import UIKit
import CLTypingLabel

class ThirdViewController: UIViewController {

    private lazy var animationLabel:CLTypingLabel = {
        let label = CLTypingLabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.charInterval = 0.06
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(animationLabel)
        
        [animationLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),animationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)].forEach { $0.isActive = true }
        
        animationLabel.text = "welcome to BodyManager"

        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: false)
    }
    
    @objc private func startAnimation(){
        print("finish process")
        let storyboard = UIStoryboard(name: "Contents", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        tabBarController.selectedIndex = 0
        self.show(tabBarController, sender: nil)
    }

}
