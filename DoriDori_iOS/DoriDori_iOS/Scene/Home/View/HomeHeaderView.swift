//
//  HomeHeaderView.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/09.
//

import UIKit
import SnapKit

enum WardState {
    case currentLocation(location: String)
    case wardLocation(location: String)
    
    var description: String {
        switch self {
        case .currentLocation(let location):
            return "지금 여기는 \(location)!"
        case .wardLocation(let location):
            return "와드를 심은 :\(location)에요!"
        }
    }
}

final class HomeHeaderView: UIView {
    
    // MARK: - Variable
    var wardState: WardState?
    
    // MARK: - UIView
    private let homeLogoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "homeLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let wardDescriptionImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "makeWard")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let wardImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "ward")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var wardTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "지금 여기는 강남구!"
        label.font = UIFont.setKRFont(weight: .bold, size: 24)
        label.textColor = .white
        return label
    }()
    
    let locationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.estimatedItemSize = .zero
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(LocationCollectionViewCell.self)
        return collectionView
    }()
    
    private let hotLocatinContainerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let hotLocationView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "hotLocation")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let hotLocationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.text = "지금 강남동이 핫🔥해요!!"
        label.font = UIFont.setKRFont(weight: .regular, size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func setupViews() {
        addSubview(homeLogoImageView)
        addSubview(wardDescriptionImageView)
        addSubview(wardImageView)
        addSubview(wardTitleLabel)
        addSubview(locationCollectionView)
        addSubview(hotLocatinContainerView)
        hotLocatinContainerView.addSubview(hotLocationView)
        hotLocatinContainerView.addSubview(hotLocationLabel)
    }
    
    private func setupConstraints() {
        homeLogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(30)
        }
        
        wardImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.trailing.equalToSuperview().inset(28)
        }
        
        wardDescriptionImageView.snp.makeConstraints {
            $0.trailing.equalTo(wardImageView.snp.leading).inset(-6)
            $0.centerY.equalTo(wardImageView)
        }
        
        wardTitleLabel.snp.makeConstraints {
            $0.top.equalTo(homeLogoImageView.snp.bottom).inset(-32)
            $0.leading.equalToSuperview().inset(30)
            $0.height.equalTo(34)
        }
        
        locationCollectionView.snp.makeConstraints {
            $0.top.equalTo(wardTitleLabel.snp.bottom).inset(-16)
            $0.leading.equalTo(wardTitleLabel.snp.leading)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        hotLocatinContainerView.snp.makeConstraints {
            $0.top.equalTo(locationCollectionView.snp.bottom).inset(-20)
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        
        hotLocationView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        hotLocationLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(16)
        }
    }
}

