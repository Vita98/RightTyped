//
//  GenericTutorialViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 05/08/23.
//

import UIKit

class GenericTutorialViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var navigateRightButton: UIButton!
    @IBOutlet weak var navigateLeftButton: UIButton!
    
    
    @IBOutlet weak var pageControlContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    var pageViewController: GenericTutorialPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GenericTutorialPageViewController{
            pageViewController = segue.destination as? GenericTutorialPageViewController
        }
    }
    
    // MARK: Configuration
    private func configure(){
        self.view.backgroundColor = .backgroundColor
        
        //buttons
        closeButton.setTitle("", for: .normal)
        navigateRightButton.setTitle("", for: .normal)
        navigateLeftButton.setTitle("", for: .normal)
        
        pageControlContainerView.layer.cornerRadius = 10
        pageControl.layer.cornerRadius = 10
        pageControl.backgroundStyle = .minimal
    }
    
    
    // MARK: Events
    @IBAction func closeButtonEvent(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func navigateRightEvent(_ sender: Any) {
    }
    
    @IBAction func navigateLeftEvent(_ sender: Any) {
    }
    
}
