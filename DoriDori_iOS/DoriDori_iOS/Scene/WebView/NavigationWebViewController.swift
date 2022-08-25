//
//  NavigationWebViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/25.
//

import UIKit

final class NavigationWebViewController: UIViewController {
    
    // navigation bar UI
    
    private let navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "left"), for: .normal)
        return button
    }()
    
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setKRFont(weight: .regular, size: 18)
        label.textColor = .white
        return label
    }()
    
    private let webViewController: BaseWebViewController
    
    init(
        url: URL,
        title: String? = nil
    ) {
        self.webViewController = BaseWebViewController(url: url)
        self.navigationTitleLabel.text = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        self.view.backgroundColor = .darkGray
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupLayouts() {
        self.view.addSubViews(self.navigationBarView, self.webViewController.view)
        self.addChild(self.webViewController)
        self.webViewController.didMove(toParent: self)
        
        self.navigationBarView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
        self.webViewController.view.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.navigationBarView.addSubViews(self.backButton, self.navigationTitleLabel)
        self.backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().offset(23)
            $0.size.equalTo(24)
            $0.bottom.equalToSuperview().inset(15)
        }
        self.navigationTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.backButton.snp.centerY)
            $0.centerX.equalToSuperview()
        }
    }
}
