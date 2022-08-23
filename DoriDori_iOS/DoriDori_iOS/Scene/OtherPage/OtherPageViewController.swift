//
//  OtherPageViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/24.
//

import Foundation
import UIKit

final class OtherPageViewController: UIViewController {
    let profileView = OtherProfileView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubViews(profileView)
        self.navigationController?.navigationBar.isHidden = true
        profileView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        self.profileView.configure(.init(nickname: "바바바바ㅏ", level: 3, profileImageURL: nil, description: "디스크립션", tags: ["너무졸려"]))
    }
}
