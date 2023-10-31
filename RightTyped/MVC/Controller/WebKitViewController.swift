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
    
    //MARK: Variables
    private var link: String?
    public var withBarIcon: Bool = true
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if withBarIcon{
            setNavigationBarView()
        }else{
            webView.removeConstraint(webViewTopConstraint)
            webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            webView.scrollView.contentInset = UIEdgeInsets(top: -70, left: 0, bottom: 0, right: 0)
        }
        load(self.link)
    }
    
    //MARK: Events
    @objc private func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Configurations
    private func load(_ link: String?){
        guard let link = link, let myURL = URL(string: link), let webView = webView else { return }
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
    
    public func loadLink(_ link: String){
        self.link = link
        load(link)
    }
}
