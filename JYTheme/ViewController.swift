//
//  ViewController.swift
//  JYTheme
//
//  Created by keyon on 2022/4/22.
//

import UIKit

class ViewController: UIViewController {

    let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    let testButton = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.th.backgroundColor = JYColor(darkColor: .black, lightColor: .white)
        
        view.addSubview(button)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
        view.addSubview(testButton)
        testButton.setTitle("测试", for: .normal)
        testButton.th.setTitleColor(JYColor(darkColor: .green, lightColor: .gray), for: .normal)
    }

    @objc private func buttonClick() {
        JYTheme.update(JYTheme.current == .night ? .day : .night)
    }

}

