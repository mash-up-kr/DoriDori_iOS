//
//  SliderRangeView.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/31.
//

import UIKit

final class SliderRangeView: UIView {
    
    private let sliderRangeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .gray500
        label.text = "100m"
        label.font = UIFont.setKRFont(weight: .medium, size: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(sliderRangeLabel)
        
        sliderRangeLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
    }
}
