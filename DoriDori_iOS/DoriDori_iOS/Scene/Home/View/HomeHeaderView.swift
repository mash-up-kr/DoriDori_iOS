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
        imageView.image = UIImage(named: "HomeLogo")
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
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var wardTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = wardState?.description
        label.textColor = .white
        return label
    }()
    
    private let emptyContainerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private let hotLocationView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

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
        addSubview(emptyContainerView)
        addSubview(hotLocationView)
    }
    
    private func setupConstraints() {
        homeLogoImageView.sn
    }
}
