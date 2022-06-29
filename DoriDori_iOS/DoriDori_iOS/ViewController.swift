//
//  ViewController.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/06/15.
//

import UIKit
import RxSwift

struct TestRequest: Requestable {
    let url: String
    let parameters: [String : Any]
    let method: HTTPMethod
    
    init(
        url: String,
        parameters: [String: Any],
        method: HTTPMethod
    ) {
        self.url = url
        self.parameters = parameters
        self.method = method
    }
}

struct TestModel: Decodable {
    struct ResultModel: Decodable, Equatable {
        let gender: String
        let email: String
    }
    let results: [ResultModel]
}

class ViewController: UIViewController {
let disposeBag = DisposeBag()
    let network = Network()
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = TestRequest(
            url: "https://randomuser.me/api/",
            parameters: ["gender": "female"],
            method: .get
        )
        Task {
            do {
                let response = try await network.fetch(
                    request: request,
                    responseModel: ResponseModel<TestModel>.self
                )
                print(response)
            } catch (let error) {
                print(error)
            }
        }
        
        network
            .fetch2(request: request, responseModel: ResponseModel<TestModel>.self)
            .subscribe(onSuccess: { [weak self] in
                print("success",$0)
            }, onError: { [weak self] in
                print("error", $0)
            })
            .disposed(by: self.disposeBag)

    }
}
