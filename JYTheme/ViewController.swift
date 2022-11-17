//
//  ViewController.swift
//  JYTheme
//
//  Created by keyon on 2022/4/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    let testButton = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.th.backgroundColor = KYColor(darkColor: .black, lightColor: .white)
        
        view.addSubview(button)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
        view.addSubview(testButton)
        testButton.setTitle("测试", for: .normal)
        testButton.th.setTitleColor(KYColor(darkColor: .green, lightColor: .gray), for: .normal)

        view.addSubview(localLabel)
        view.addSubview(localButton)

        localLabel.snp.makeConstraints { make in
            make.left.equalTo(100)
            make.top.equalTo(200)
        }

        localButton.snp.makeConstraints { make in
            make.left.equalTo(100)
            make.top.equalTo(300)
        }


    }

    @objc private func buttonClick() {
        KYTheme.update(KYTheme.current == .night ? .day : .night)
    }

    private var toggle = true
    @objc private func localButtonClick() {
        if toggle {
            KYLocalizationPreference.current = .specified(.English.us)
        } else {
            KYLocalizationPreference.current = .specified(.Chinese.simplified)
        }
        toggle.toggle()
    }

    private lazy var localLabel: UILabel = {
        let label = UILabel()
        label.l10n.attributedText = KYLocalizerAttributeBuilder {
            "bitmart_test".localized().ky.foregroundColor(KYColor(darkColor: .white, lightColor: .gray).currentThemeColor)
            "bitmart_hello".localized().ky.foregroundColor(KYColor(darkColor: .red, lightColor: .blue).currentThemeColor)
            "bitmart_world".localized().ky.foregroundColor(KYColor(darkColor: .orange, lightColor: .yellow).currentThemeColor)
        }
        return label
    }()

    private lazy var localButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(localButtonClick), for: .touchUpInside)
        button.l10n.title(for: .normal, builder: KYLocalizerStringBuilder{
            "bitmart_test".localized()
        })
        return button
    }()
}

