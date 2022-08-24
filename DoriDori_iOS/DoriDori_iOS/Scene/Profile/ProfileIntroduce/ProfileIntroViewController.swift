//
//  ProfileIntroViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/25.
//

import UIKit
import RxSwift

final class ProfileIntroViewController: UIViewController {
    
    @IBOutlet private weak var profileIntroTextField: UnderLineTextField!
    @IBOutlet private weak var nextButton: UIButton!
    
    private let viewModel: ProfileIntroduceViewModel = .init()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingViewModel()
    }
    
    // MARK: - Bind
    private func settingViewModel() {
        profileIntroTextField.viewModel = UnderLineTextFieldViewModel(titleLabelType: .profile, inputContentType: .nickname, keyboardType: .default)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileKeywordViewController") as? ProfileKeywordViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
