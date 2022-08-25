//
//  ProfileUploadViewController.swift
//  DoriDori_iOS
//
//  Created by 김지인 on 2022/08/09.
//

import UIKit
import Photos

class ProfileUploadViewController: UIViewController {
    
    @IBOutlet private weak var profileView: UIImageView!
    @IBOutlet private weak var uploadPictureButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSignUpNavigationBar()
    }
    
    private func openLibrary() {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
            
        }
    }
    
    private func requestPHPhotoLibraryAuthorization(completion: @escaping () -> Void) {
        if #available(iOS 14, *) {
            switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .authorized, .limited:
                        completion()
                        print("권한이 부여 됬습니다. 앨범 사용이 가능합니다")
                    case .denied:
                        print("권한이 거부 됬습니다. 앨범 사용 불가합니다.")
                    default:
                        print("그 밖의 권한이 부여 되었습니다.")
                    }
                }
            case .authorized: //모든 권한 허용
                completion()
            case .limited: //선택한 사진만 허용
                print("limited")
            case .denied: //거부
                let alert = UIAlertController(title: "사진", message: "권한이 거부 되어 앨범 사용이 불가합니다.", preferredStyle: UIAlertController.Style.alert)
                let defaultAction =  UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                alert.addAction(defaultAction)
                self.present(alert, animated: true)
            default:
                print("Unimplemented")
            }
        }
        else { //14이전
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    switch status {
                    case .authorized:
                        print("권한이 부여 됬습니다. 앨범 사용이 가능합니다")
                    case .denied:
                        print("권한이 거부 됬습니다. 앨범 사용 불가합니다.")
                    default:
                        print("그 밖의 권한이 부여 되었습니다.")
                    }
                })
            case .restricted:
                print("restricted")
            case .denied:
                print("denined")
            case .authorized:
                print("autorized")
            default:
                print("unKnown")
            }
            
        }
    }

    
    @IBAction func tapPhotoUpload(_ sender: UIButton) {
        requestPHPhotoLibraryAuthorization {
            self.openLibrary()
        }
    }
    
    @IBAction func tapNextButton(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileKeywordViewController") as? ProfileKeywordViewController
        else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension ProfileUploadViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileView.layer.cornerRadius = profileView.frame.height / 2
            profileView.contentMode = .scaleToFill
            profileView.image = image
        }
        dismiss(animated: true)
        //버튼 변경
        self.nextButton.backgroundColor = UIColor(named: "lime300")
        self.nextButton.setTitleColor(UIColor(named: "darkGray"), for: .normal)
        self.nextButton.setTitle("다음", for: .normal)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}


