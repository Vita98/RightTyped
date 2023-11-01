//
//  WebKitViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 31/10/23.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {

    //MARK: Outlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Variables
    private var link: String?
    public var withBarIcon: Bool = true
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if withBarIcon{
            setNavigationBarView()
        }else{
            webViewTopConstraint.isActive = false
            webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            webView.scrollView.contentInset = UIEdgeInsets(top: -70, left: 0, bottom: 0, right: 0)
        }
        webView.navigationDelegate = self
        webView.alpha = 0
        load(self.link)
    }
    
    //MARK: Configurations
    private func load(_ link: String?){
        guard let link = link, let myURL = URL(string: link), let webView = webView else { return }
        setStatus(loading: true)
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
    
    public func loadLink(_ link: String){
        self.link = link
        load(link)
    }
    
    private func setStatus(loading: Bool){
        if loading {
            UIView.animate(withDuration: 0.3) {[weak self] in
                self?.webView.alpha = 0
                self?.activityIndicator.isHidden = false
                self?.activityIndicator.startAnimating()
            }
        } else {
            UIView.animate(withDuration: 0.3) {[weak self] in
                self?.webView.alpha = 1
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }
    }
}

//MARK: Navigation delegate
extension WebKitViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setStatus(loading: false)
    }
}
