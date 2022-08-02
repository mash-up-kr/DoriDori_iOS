//
//  HomeMySpeechBubbleView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/02.
//

import UIKit

final class HomeMySpeechBubbleView: MySpeechBubbleView {
    // MARK: - UIComponent
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more"), for: .normal)
        return button
    }()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray200
        label.font = UIFont.setKRFont(weight: .medium, size: 13)
        return label
    }()
    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        return stackView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.setKRFont(weight: .medium, size: 16)
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray600
        label.font = UIFont.setKRFont(weight: .medium, size: 12)
        return label
    }()
    private let verticalSeperatedView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray700
        return view
    }()
    private let updatedTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray600
        label.font = UIFont.setKRFont(weight: .medium, size: 12)
        return label
    }()
    private let locationTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    private let horizontalSeperatedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray800
        return view
    }()
    private let handButton: UIButton = {
        let button = UIButton()
        return button
    }()
    private let buttonSeperaterView1: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        return view
    }()
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chat"), for: .normal)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6)
        return button
    }()
    private let buttonSeperaterView2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray800
        return view
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "reply"), for: .normal)
        button.setTitle("공유", for: .normal)
        button.setTitleColor(UIColor.gray500, for: .normal)
        button.titleLabel?.font = UIFont.setKRFont(weight: .medium, size: 12)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 6)
        return button
    }()
    
    override init(
        borderWidth: CGFloat = 1,
        borderColor: UIColor = .gray900,
        backgroundColor: UIColor = .gray900
    ) {
        super.init(
            borderWidth: borderWidth,
            borderColor: borderColor,
            backgroundColor: backgroundColor
        )
//        self.setupLayouts()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
