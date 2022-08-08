//
//  NicknameSettingViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/08.
//

import UIKit

class NicknameSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileUploadViewController") as? ProfileUploadViewController
        else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
