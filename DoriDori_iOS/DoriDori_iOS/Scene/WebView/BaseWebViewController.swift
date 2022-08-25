//
//  BaseWebViewController.swift
//  DoriDori_iOS
//
//  Created by JeongMinho on 2022/07/10.
//

import UIKit
import SnapKit
import WebKit

class BaseWebViewController: UIViewController {
    private(set) var webView: WKWebView = WKWebView()
    var url: URL?
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        setupWkWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        setupViews()
        setupCookies()
        setupConstraints()
    }
    
    private func setupViews() {
        self.view.addSubview(webView)
    }
    
    private func setupConstraints() {
        webView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupWkWebView() {
        guard let url = self.url else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupCookies() {
        guard let accessToken = UserDefaults.accessToken else { return }
        guard let cookie = HTTPCookie(properties: [
            .domain: "https://mash-up-bangwidae-web-temp-9pcf7l7bh-kimbangg.vercel.app",
            .path: "/open-inquiry",
            .name: "zz",
            .value: accessToken
        ]) else { return }
        self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        print("cookie", cookie)
    }
}
