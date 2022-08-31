//
//  HomeRangeView.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/31.
//

import UIKit

final class HomeRangeView: UIView {
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.text = "질문 범위 설정"
        label.font = UIFont.setKRFont(weight: .bold, size: 18)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .gray500
        label.text = "선택한 범위의 질문반 볼 수 있어요."
        label.font = UIFont.setKRFont(weight: .regular, size: 13)
        return label
    }()
    
    
    private let rangeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .lime300
        label.text = "250M"
        label.font = UIFont.setKRFont(weight: .bold, size: 18)
        return label
    }()
    
    private let separatorView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    private let rangeImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "range250")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let rangeSlider: UISlider = {
        let slider: UISlider = UISlider()
        return slider
    }()
    
    private let sliderLabelStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    private let cancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.setKRFont(weight: .bold, size: 16)
        button.titleLabel?.text = "취소"
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button: UIButton = UIButton()
        button.titleLabel?.textColor = .black
        button.titleLabel?.font = UIFont.setKRFont(weight: .bold, size: 16)
        button.titleLabel?.text = "확인"
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(rangeLabel)
        addSubview(rangeImageView)
        addSubview(rangeSlider)
        addSubview(sliderLabelStackView)
        addSubview(cancelButton)
        addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(30)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(8)
            $0.leading.equalTo(titleLabel)
        }
    }
}
