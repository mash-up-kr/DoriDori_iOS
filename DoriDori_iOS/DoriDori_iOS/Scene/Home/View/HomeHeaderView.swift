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
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(LocationCollectionViewCell.self)
        return collectionView
    }()
    
    private let locationRangeContainerView: UIView = {
        let view: UIView = UIView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 4
        return view
    }()
    
    let locationRangeButton: UIButton = UIButton()
    
    let locationRangeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.setKRFont(weight: .bold, size: 14)
        label.text = "1000M"
        label.textColor = .white
        return label
    }()
    
    private let locationRangeImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "location")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        addSubview(locationRangeContainerView)
        
        locationRangeContainerView.addSubview(locationRangeLabel)
        locationRangeContainerView.addSubview(locationRangeImageView)
        locationRangeContainerView.addSubview(locationRangeButton)
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
        
        locationRangeContainerView.snp.makeConstraints {
            $0.top.equalTo(wardTitleLabel.snp.bottom).inset(-16)
            $0.leading.equalTo(wardTitleLabel.snp.leading)
            $0.height.equalTo(34)
            $0.width.equalTo(83)
        }
        
        locationRangeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
        }
        
        locationRangeImageView.snp.makeConstraints {
            $0.centerY.equalTo(locationRangeLabel)
            $0.leading.equalTo(locationRangeLabel.snp.trailing).offset(6)
            $0.size.equalTo(12).priority(999)
        }
    }
}

