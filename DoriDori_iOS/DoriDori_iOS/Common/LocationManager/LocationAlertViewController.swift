//
//  LocationAlertViewController.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/31.
//

import UIKit
import RxSwift

final class LocationAlertViewController: UIViewController {
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.setKRFont(weight: .bold, size: 18)
        label.text = "주변 커뮤니티 접속을 위해\n위치 정보를 공유해주세요!"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.setKRFont(weight: .regular, size: 14)
        label.text = "도리도리 사용에 꼭 필요한 정보예요"
        label.textAlignment = .center
        return label
    }()
    
    private let locationDoriDoriImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "medori5")
        return imageView
    }()
    
    private let locationAgreeButton: UIButton = {
        let button = UIButton()
        button.setTitle("위치정보 허용하러 가기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .bold, size: 14)
        button.backgroundColor = UIColor.lime300
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.setupLayouts()
        self.bind()
    }
    
    private func bind() {
        self.locationAgreeButton.rx.throttleTap
            .bind(with: self) { owner, _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    self.dismiss(animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setupLayouts() {
        self.alertView.addSubViews(self.titleLabel, self.subTitleLabel, self.locationDoriDoriImageView, self.locationAgreeButton)
        self.view.addSubview(self.alertView)
        
        self.alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(28)
        }
        self.subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(self.titleLabel)
        }
        self.locationDoriDoriImageView.snp.makeConstraints {
            $0.top.equalTo(self.subTitleLabel.snp.bottom).offset(33)
            $0.width.equalTo(95)
            $0.height.equalTo(105)
            $0.centerX.equalToSuperview()
        }
        self.locationAgreeButton.snp.makeConstraints {
            $0.top.equalTo(self.locationDoriDoriImageView.snp.bottom).offset(27)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(16)
        }
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
