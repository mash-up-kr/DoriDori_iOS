//
//  DoriDoriToastView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/20.
//

import Toast
import UIKit
import SnapKit

final class DoriDoriToastView: UIView {
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.setKRFont(weight: .regular, size: 13)
        return label
    }()
    
    private let duration: TimeInterval
    
    init(
        text: String,
        duration: TimeInterval = 4.0
    ) {
        self.duration = duration
        super.init(frame: CGRect(x: 0, y: 0, width: 256, height: 38))
        self.textLabel.text = text
        self.setupLayouts()
        self.backgroundColor = UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 0.8)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    init(
        text: String,
        bgColor: UIColor,
        duration: TimeInterval = 4.0
    ) {
        self.duration = duration
        super.init(frame: CGRect(x: 0, y: 0, width: 256, height: 38))
        self.textLabel.text = text
        self.setupLayouts()
        self.backgroundColor = bgColor
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
                as? SceneDelegate else {
            return
        }
        let x = UIScreen.main.bounds.width / 2
        sceneDelegate.window?.showToast(
            self,
            duration: self.duration,
            point: CGPoint(x: x, y: 58),
            completion: nil
        )
    }
}

extension DoriDoriToastView {
    private func setupLayouts() {
        self.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().inset(32)
        }
    }
}
