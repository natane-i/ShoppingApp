//
//  WebViewController.swift
//  ShoppingApp
//
//  Created by spark-01 on 2024/07/09.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return webView
    }()
    
    var url: URL?
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        
        guard let url = url else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        // NavigationBarの設定
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 58))
        view.addSubview(navigationBar)
        
        let closeItem = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(closeWebView))
        closeItem.tintColor = .black
        let navItem = UINavigationItem(title: "")
        navItem.rightBarButtonItem = closeItem
        navigationBar.items = [navItem]
       
    }
    
    @objc func closeWebView() {
        dismiss(animated: true, completion: nil)
    }
}
