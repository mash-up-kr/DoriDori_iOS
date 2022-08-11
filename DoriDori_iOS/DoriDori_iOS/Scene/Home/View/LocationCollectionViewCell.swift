//
//  LocationCollectionViewCell.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/02.
//

import UIKit

final class LocationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier: String = "LocationCollectionViewCell"
    
    // MAKR: - UIView
    let locationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.setKRFont(weight: .bold, size: 14)
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.gray800.cgColor
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let currentLocationImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
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
    
    // MARK: - Methods
    private func setupViews() {
        contentView.addSubview(locationLabel)
    }
    
    private func setupConstraints() {
        locationLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
