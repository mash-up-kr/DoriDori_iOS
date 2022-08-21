//
//  QuestionViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/21.
//

import UIKit

final class QuestionViewController: UIViewController {
    
    // MARK: - UIComponents
    
    private let navigationBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "left"), for: .normal)
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.text = "질문하기"
        label.textColor = UIColor.white
        label.font = UIFont.setKRFont(weight: .regular, size: 18)
        return label
    }()
    
    private let registNavigationButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.setTitleColor(UIColor.gray700, for: .normal)
        return button
    }()
    
    private let selectView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray900
        view.layer.borderColor = UIColor.gray800.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let nicknameDropDownView = DropDownView(title: "닉네임")
    private let wardDropDownView = DropDownView(title: "현위치")
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.inputAccessoryView = self.registButtonContainerView
        textView.tintColor = .lime300
        textView.font = UIFont.setKRFont(weight: .regular, size: 16)
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setKRFont(weight: .regular, size: 16)
        label.textColor = .gray600
        return label
    }()
    
    private let textCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/300"
        label.textColor = .gray600
        label.font = UIFont.setKRFont(weight: .regular, size: 13)
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        return view
    }()
    
    private let registButtonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let registButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.gray300, for: .normal)
        button.setTitle("질문등록", for: .normal)
        button.backgroundColor = .gray700
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Properties
    
    override var hidesBottomBarWhenPushed: Bool {
        get { self.navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        self.view.backgroundColor = .darkGray
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
}

// MARK: - Private functions

extension QuestionViewController {
    
    private func setupLayouts() {
        self.view.addSubViews(self.navigationBackButton, self.navigationTitle, self.registNavigationButton, self.selectView, self.textView, self.textCountLabel, self.dividerView, self.registButtonContainerView)
        self.registButtonContainerView.addSubview(self.registButton)
        self.selectView.addSubViews(self.nicknameDropDownView, self.wardDropDownView)
        
        self.navigationBackButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.size.equalTo(24)
            $0.leading.equalToSuperview().offset(23)
        }
        self.navigationTitle.snp.makeConstraints {
            $0.top.equalTo(self.navigationBackButton.snp.top)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(26)
        }
        self.registNavigationButton.snp.makeConstraints {
            $0.top.equalTo(self.navigationBackButton.snp.top)
            $0.trailing.equalToSuperview().inset(28)
        }
        
        self.selectView.snp.makeConstraints {
            $0.top.equalTo(self.navigationTitle.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
        self.textView.snp.makeConstraints {
            $0.top.equalTo(self.selectView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(402)
        }
        self.textCountLabel.snp.makeConstraints {
            $0.top.equalTo(self.textView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(30)
        }
        self.dividerView.snp.makeConstraints {
            $0.top.equalTo(self.textCountLabel.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        self.registButtonContainerView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        self.registButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(54)
        }
        
        self.nicknameDropDownView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.bottom.equalToSuperview().inset(9)
            $0.leading.equalToSuperview().offset(30)
        }
        self.wardDropDownView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.nicknameDropDownView)
            $0.leading.equalTo(self.nicknameDropDownView.snp.trailing).offset(20)
        }
    }
}
