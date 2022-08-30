//
//  HomeEmptyView.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/08/28.
//

import UIKit
import Lottie

final class HomeEmptyView: UIView {
    
    private let animationView: AnimationView = {
        let view: AnimationView = AnimationView()
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(animationView)
        animationView.play()
    }
}
