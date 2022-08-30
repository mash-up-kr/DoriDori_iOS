////
////  TextFieldAlertViewController.swift
////  DoriDori_iOS
////
////  Created by Seori on 2022/08/30.
////
//
//import UIKit
//
//final class TextFieldAlertViewController: UIViewController {
//    private let alertView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .gray800
//        view.layer.cornerRadius = 12
//        view.clipsToBounds = true
//        return view
//    }()
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = UIFont.setKRFont(weight: .bold, size: 18)
//        return label
//    }()
//
//    private let messageLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.setKRFont(weight: .medium, size: 14)
//        label.textAlignment = .center
//        return label
//    }()
//
//    private let normalButton: UIButton = {
//        let button = UIButton()
//        button.layer.cornerRadius = 8
//        button.layer.borderColor = UIColor.gray600.cgColor
//        button.layer.borderWidth = 1
//        button.backgroundColor = .clear
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont.setKRFont(weight: .regular, size: 14)
//        return button
//    }()
//
//    private let
//
//    private let emphasisButton: UIButton = {
//        let button = UIButton()
//        button.layer.cornerRadius = 8
//        button.layer.borderColor = UIColor.lime300.cgColor
//        button.backgroundColor = UIColor.lime300
//
//        button.setTitleColor(.darkGray, for: .normal)
//        button.titleLabel?.font = UIFont.setKRFont(weight: .regular, size: 14)
//        return button
//    }()
//
//    private let buttonStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.spacing = 10
//        return stackView
//    }()
//    private let disposeBag: DisposeBag
//    private let normalAction: AlertAction
//    private let emphasisAction: AlertAction
//}
