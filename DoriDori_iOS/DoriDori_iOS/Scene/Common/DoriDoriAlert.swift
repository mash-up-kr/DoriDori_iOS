//
//  DoriDoriAlert.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import UIKit
import RxSwift
import RxCocoa

struct DoriDoriAction {
    let title: String
    let action: (() -> Void)
}

final class DoriDoriAlert: UIViewController {
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.setKRFont(weight: .bold, size: 18)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setKRFont(weight: .medium, size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let normalButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.gray600.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .regular, size: 14)
        return button
    }()
    
    private let emphasisButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.lime300.cgColor
        button.backgroundColor = UIColor.lime300
        
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .regular, size: 14)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    private let disposeBag: DisposeBag
    private let normalAction: DoriDoriAction
    private let emphasisAction: DoriDoriAction
    
    init(
        title: NSAttributedString,
        message: String,
        normalAction: DoriDoriAction,
        emphasisAction: DoriDoriAction
    ) {
        self.disposeBag = .init()
 
     
        self.normalAction = normalAction
        self.emphasisAction = emphasisAction
        super.init(nibName: nil, bundle: nil)
        self.normalButton.setTitle(normalAction.title, for: .normal)
        self.emphasisButton.setTitle(emphasisAction.title, for: .normal)
        self.titleLabel.attributedText = title
        self.messageLabel.text = message
        self.setupView()
        self.setupLayouts()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate
                        as? SceneDelegate else {
                    return
                }
        sceneDelegate.window?.rootViewController?.present(self, animated: true)
    }
}

// MARK: - Private functions

extension DoriDoriAlert {
    
    private func setupView() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.alertView.backgroundColor = .gray800
        self.alertView.layer.cornerRadius = 12
        self.alertView.clipsToBounds = true
    }
    
    private func setupLayouts() {
        self.buttonStackView.addArrangedSubViews(self.normalButton, self.emphasisButton)
        self.normalButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        self.emphasisButton.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        self.alertView.addSubViews(self.titleLabel, self.messageLabel, self.buttonStackView)
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(28)
        }
        self.messageLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(self.titleLabel)
        }
        self.buttonStackView.snp.makeConstraints {
            $0.top.equalTo(self.messageLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        self.view.addSubViews(self.alertView)
        self.alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func bind() {
        self.normalButton.rx.throttleTap
            .bind(with: self) { owner, _ in
                owner.normalAction.action()
            }
            .disposed(by: self.disposeBag)
        
        self.emphasisButton.rx.throttleTap
            .bind(with: self) { owner, _ in
                owner.emphasisAction.action()
            }
            .disposed(by: self.disposeBag)
    }
}
