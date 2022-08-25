//
//  ProfileUploadViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/09.
//

import UIKit

class ProfileUploadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }
    

    @IBAction func tapNextButton(_ sender: UIButton) {
        guard let profileKeywordVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileIntroViewController") as? ProfileIntroViewController
        else { return }
        navigationController?.pushViewController(profileKeywordVC, animated: true)
    }

}
