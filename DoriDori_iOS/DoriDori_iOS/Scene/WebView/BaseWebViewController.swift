//
//  BaseWebViewController.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/10.
//

import UIKit
import SnapKit
import WebKit

// 필요시에 여기에서 navigation header를 지정해야한다.
final class BaseWebViewController: UIViewController, WKNavigationDelegate {
//
//    private let backButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "left"), for: .normal)
//        return button
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//
//        return label
//    }()
//
//
//    private func setLayouts() {
//        self.view.addSubViews(self.backButton, self.titleLabel)
//        self.backButton.snp.makeConstraints {
//            $0.top.equalTo(self.view.safeAreaLayoutGuide)
//            $0.leading.equalToSuperview().offset(10)
//            $0.size.equalTo(24)
//        }
//
//        self.titleLabel.snp.makeConstraints {
//            $0.top.equalTo(self.backButton.snp.top)
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalTo(self.backButton)
//        }
//    }
    
    
    private var webView: WKWebView!
    private let url: URL
    
    init(url: URL) {
        self.url = url
        let contentController = WKUserContentController()
        if let cookie = HTTPCookie(properties: [
            .domain: "https://dori-dori.netlify.app",
            .path: "/open-inquiry",   // ?? 모르겠음
            .name: "doridori accessToken",  // cookie의 이름
            .value: dummyAccessToken,    // cookie에 보낼 값
            .maximumAge: 7200   // cookie지속 시간
        ]) {
            let configuraction = WKWebViewConfiguration()
            let webViewDataStore = WKWebsiteDataStore.nonPersistent()
            webViewDataStore.httpCookieStore.setCookie(cookie)
            configuraction.websiteDataStore = webViewDataStore
            
            configuraction.userContentController = contentController
            
            self.webView = WKWebView(frame: .zero, configuration: configuraction)
            
            print(cookie)
        }
        else { self.webView = WKWebView() }

        
        super.init(nibName: nil, bundle: nil)
        contentController.add(self, name: "Common")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        setupWkWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
    }
    
    // 로딩중 옵저빙
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print("웹뷰 로딩 중")
        }
    }
    
    // 로드 및 로딩중 옵저버 등록
    private func setupWkWebView() {
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        
    }

}

extension BaseWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message, "message")
        print(message.body, "body")
        guard message.name == "Common",
              let messages = message.body as? [String: Any],
              let cmd = messages["cmd"],
              let params = messages["parameters"] as? [String: String],
              let deeplink = params["value"] else { return }
        print("cmd", cmd)
        print("deeeplink", deeplink)
        guard let url = URL(string: deeplink) else { return }
        print("ddeep link to url", url)
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

            return
        }
    }
    
}
