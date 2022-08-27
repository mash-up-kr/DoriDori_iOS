//
//  ModalTypeWebViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/27.
//

import Foundation
import UIKit

final class ModalTypeWebViewController: UIViewController {
    
    private let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let doridoriLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "homeLogo")
        return imageView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "page_delete"), for: .normal)
        return button
    }()
    
    private let webViewController: BaseWebViewController
    private let type: DoriDoriWeb
    
    init(
        type: DoriDoriWeb,
        title: String? = nil
    ) {
        self.type = type
        self.webViewController = BaseWebViewController(path: type.path)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayouts()
        self.view.backgroundColor = .gray900
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupLayouts() {
        self.view.addSubViews(self.topView, self.webViewController.view)
        self.addChild(self.webViewController)
        self.webViewController.didMove(toParent: self)
        
        self.topView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }

        self.webViewController.view.snp.makeConstraints {
            $0.top.equalTo(self.topView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        self.topView.addSubViews(self.doridoriLogo, self.closeButton)
        self.doridoriLogo.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(30)
            $0.width.equalTo(100)
            $0.height.equalTo(25)
        }
        self.closeButton.snp.makeConstraints {
            $0.centerY.equalTo(self.doridoriLogo.snp.centerY)
            $0.size.equalTo(24)
            $0.trailing.equalToSuperview().inset(27)
        }
    }
}
