//
//  OtherPageViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/24.
//

import Foundation
import UIKit

final class OtherPageViewController: UIViewController {
    
    // MARK: - UIComponents
    
    private let profileView = OtherProfileView()
    private let profileDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        return view
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
        self.setupUI()
        self.profileView.configure(OtherProfileItem(nickname: "도리를찾아서", level: 1, profileImageURL: nil, description: "ㅇㄴ녕하세요 디즈니 영화 다 추천해드려요", tags: ["디즈니", "영화", "애니메이션"], representativeWard: "강남구"))
    }

    private func setupLayouts() {
        let contentViewController = OtherProfileContentViewController()
        
        self.view.addSubViews(self.profileView, self.profileDividerView, contentViewController.view)
        self.profileView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        self.profileDividerView.snp.makeConstraints {
            $0.top.equalTo(self.profileView.snp.bottom)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        contentViewController.view.snp.makeConstraints {
            $0.top.equalTo(self.profileDividerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .gray900
        self.navigationController?.navigationBar.isHidden = true
    }
}
