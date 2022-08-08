//
//  TermsOfServiceViewContoller.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/07/21.
//

import UIKit
import RxSwift
import RxCocoa

final class TermsOfServiceViewContoller: UIViewController {
    
    @IBOutlet private weak var allAgreeButton: UIButton!
    @IBOutlet private weak var allAgreeOutLineView: UIView!
    
    @IBOutlet private weak var compulsoryAgreeButton: UIButton!
    @IBOutlet private weak var currentLocationAgreeButton: UIButton!
    @IBOutlet private weak var finalAgreeButton: UIButton!
    
    private var viewModel: TermsOfServiceViewModel = .init()
    private var disposeBag = DisposeBag()
    private var agreeBool: Bool = false
    

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel: viewModel)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }
    
    private func bind(viewModel: TermsOfServiceViewModel) {
        let input = TermsOfServiceViewModel.Input(allAgree: allAgreeButton.rx.tap.scan(false) { (lastState, newValue) in
            !lastState
        }.asObservable())
        
        let output = viewModel.transform(input: input)
        output.isValidButton.bind { [weak self] isValid in
            //Setting allAgree
            self?.allAgreeButton.isSelected = isValid
            let buttonImage = isValid ? UIImage(named: "checkbox") : UIImage(named: "checkbox_outline")
            let toogleColor = isValid ? UIColor(named: "lime300") : UIColor(named: "gray800")
            let buttonTitleColor = isValid ? UIColor(named: "darkGray") : UIColor(named: "gray300")
            self?.allAgreeButton.setImage(buttonImage, for: .selected)
            self?.allAgreeOutLineView.borderColor = toogleColor
            //Setting finalAgree
            self?.finalAgreeButton.isEnabled = isValid
            self?.finalAgreeButton.backgroundColor = toogleColor
            self?.finalAgreeButton.setTitleColor(buttonTitleColor, for: .normal)
            //Setting Other
            self?.compulsoryAgreeButton.setImage(buttonImage, for: .normal)
            self?.currentLocationAgreeButton.setImage(buttonImage, for: .normal)
        }.disposed(by: disposeBag)
    }

    
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Profile", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "NicknameSettingViewController") as? NicknameSettingViewController
        else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
}
