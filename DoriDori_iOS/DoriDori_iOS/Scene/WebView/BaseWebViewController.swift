//
//  BaseWebViewController.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/10.
//

import UIKit
import SnapKit
import WebKit


final class BaseWebViewController: UIViewController, WKNavigationDelegate {
    
    private enum Constant {
        static let estimatedProgress = "estimatedProgress"
    }

    private let domain: String = "https://dori-dori.netlify.app"
    private var webView: WKWebView!
    private let path: String
    
    private let activityIndicator = DoriDoriActivityIndicator()
    init(path: String) {
        self.path = path
        let contentController = WKUserContentController()
        if let cookie = HTTPCookie(properties: [
            .domain: self.domain,
            .path: "/open-inquiry",   // ?? 모르겠음
            .name: "accessToken",  // cookie의 이름
            .value: UserDefaults.accessToken ?? "",    // cookie에 보낼 값
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
        self.setupView()
        self.activityIndicator.startAnimating()
        self.webView.scrollView.contentOffset = .zero
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == Constant.estimatedProgress {
            guard let loadingValue = change?[.newKey] as? Double else { return }
            if loadingValue == 1.0 {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func setupView() {
        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor.clear
        self.webView.addSubview(self.activityIndicator)
        self.navigationController?.navigationBar.isHidden = true
        self.activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(48)
        }
    }
    

    private func setupWkWebView() {
        guard let webURL = URL(string: "\(self.domain)\(self.path)") else { return }
        let request = URLRequest(url: webURL)
        webView.load(request)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
    }
}

// MARK: -  WKScriptMessageHandler

extension BaseWebViewController: WKScriptMessageHandler {
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
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
