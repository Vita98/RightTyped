//
//  GenericTutorialViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 05/08/23.
//

import UIKit

class ManagerTutorialViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var navigateRightButton: UIButton!
    @IBOutlet weak var navigateLeftButton: UIButton!
    @IBOutlet weak var pageControlContainerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: Custom component
    var pageViewController: GenericTutorialPageViewController?
    var model: TutorialModel? {
        didSet{
            configureModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureModel()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GenericTutorialPageViewController{
            pageViewController = segue.destination as? GenericTutorialPageViewController
        }
    }
    
    // MARK: - Configuration
    private func configure(){
        self.view.backgroundColor = .backgroundColor
        
        //buttons
        closeButton.setTitle("", for: .normal)
        navigateRightButton.setTitle("", for: .normal)
        navigateLeftButton.setTitle("", for: .normal)
        
        pageControlContainerView.layer.cornerRadius = 12.5
        pageControl.layer.cornerRadius = 12.5
        pageControl.backgroundStyle = .minimal
        pageControl.numberOfPages = model?.pageModels.count ?? 0
        pageViewController?.pageControl = self.pageControl
    }
    
    private func configureModel(){
        guard let model = self.model else { return }
        pageViewController?.model = model
    }
    
    
    // MARK: - Events
    @IBAction func closeButtonEvent(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func navigateRightEvent(_ sender: Any) {
        pageViewController?.navigate(direction: .after)
    }
    
    @IBAction func navigateLeftEvent(_ sender: Any) {
        pageViewController?.navigate(direction: .before)
    }
    
}
