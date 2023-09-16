//
//  LoadingViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 11/09/23.
//

import UIKit

class LoadingViewController: UIViewController {
    
    var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .componentColor
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: Configuration
    private func configure(){
        self.view.backgroundColor = .black.withAlphaComponent(0.3)
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    
    //MARK: Public configuration
    public func show(in controller: UIViewController){
        spinner.startAnimating()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        controller.present(self, animated: true, completion: nil)
    }

}
