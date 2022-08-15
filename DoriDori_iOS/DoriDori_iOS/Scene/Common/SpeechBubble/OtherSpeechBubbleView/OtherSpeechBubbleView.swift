//
//  OtherSpeechBubbleView.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/07/23.
//

import UIKit

class OtherSpeechBubbleView: UIView {
    
    private let _borderWidth2: CGFloat
    private let _borderColor: UIColor
    private let _backgroundColor: UIColor
    
    init(
        borderWidth: CGFloat = 1,
        borderColor: UIColor = .gray900,
        backgroundColor: UIColor = .gray900
    ) {
        self._borderWidth2 = borderWidth
        self._borderColor = borderColor
        self._backgroundColor = backgroundColor
        
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = _borderWidth2
        let bottom = rect.height - _borderWidth2
        let right = rect.width - _borderWidth2
        let top = _borderWidth
        let left: CGFloat = 10
        
        // 아래
        bezierPath.move(to: CGPoint(x: right - 18, y: bottom))
        bezierPath.addLine(to: CGPoint(x: 17 + _borderWidth, y: bottom))
        bezierPath.addCurve(to: CGPoint(x: left, y: bottom - 18),
                            controlPoint1: CGPoint(x: 7.61 + _borderWidth, y: bottom),
                            controlPoint2: CGPoint(x: left, y: bottom - 7.61))
        
        // 왼쪽
        bezierPath.addLine(to: .init(x: left, y: 45))
        bezierPath.addLine(to: .init(x: 0, y: 37))
        bezierPath.addLine(to: .init(x: left, y: 37))
        bezierPath.addLine(to: CGPoint(x: left, y: 17 + _borderWidth))
        bezierPath.addCurve(to: CGPoint(x: 17 + _borderWidth, y: top),
                            controlPoint1: CGPoint(x: 10, y: 7.61 + _borderWidth),
                            controlPoint2: CGPoint(x: 7.61 + _borderWidth, y: top))
        
        
        // 위쪽
        bezierPath.addLine(to: CGPoint(x: right - 18, y: top))
        bezierPath.addCurve(to: CGPoint(x: right, y: 18 + _borderWidth),
                            controlPoint1: CGPoint(x: right, y: top),
                            controlPoint2: CGPoint(x: right, y: 7.61 + _borderWidth))
        
        // 오른쪽
        bezierPath.addLine(to: CGPoint(x: right, y: bottom - 18))
        bezierPath.addCurve(to: CGPoint(x: right - 18, y: bottom),
                            controlPoint1: CGPoint(x: right, y: bottom - 7.61),
                            controlPoint2: CGPoint(x: right, y: bottom))
        
        self._borderColor.set()
        bezierPath.stroke()
        self._backgroundColor.setFill()
        bezierPath.fill()
    }

}
