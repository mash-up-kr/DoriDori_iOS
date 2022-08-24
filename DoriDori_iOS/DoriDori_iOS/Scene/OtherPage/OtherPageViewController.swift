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
        self.view.backgroundColor = .gray900
        self.navigationController?.navigationBar.isHidden = true
        profileView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        self.profileView.configure(OtherProfileItem(nickname: "도리를찾아서", level: 1, profileImageURL: nil, description: "ㅇㄴ녕하세요 디즈니 영화 다 추천해드려요", tags: ["디즈니", "영화", "애니메이션"], representativeWard: "강남구"))
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get { self.navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
}
