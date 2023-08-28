//
//  PremiumViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 18/08/23.
//

import UIKit

class PremiumViewController: UIViewController {

    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var navigateRightButton: UIButton!
    @IBOutlet weak var navigateLeftButton: UIButton!
    @IBOutlet weak var pageControlContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Configuration
    private func configure(){
        setNavigationBarView()
        premiumLabel.textColor = .componentColor
        view.backgroundColor = .backgroundColor
        
        //page control section
        navigateRightButton.setTitle("", for: .normal)
        navigateLeftButton.setTitle("", for: .normal)
        navigateLeftButton.setImage(navigateLeftButton.image(for: .normal)?.withTintColor(.componentColor.disabled()), for: .normal)
        pageControlContainerView.layer.cornerRadius = 12.5
        pageControl.layer.cornerRadius = 12.5
        pageControl.backgroundStyle = .minimal
//        pageControl.numberOfPages = model?.pageModels.count ?? 0
//        pageViewController?.pageControl = self.pageControl
    }

}
