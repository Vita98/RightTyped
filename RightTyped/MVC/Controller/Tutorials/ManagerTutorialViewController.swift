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
    var fromSettings = false
    var customFinalAction: (() -> Void)?
    var isFinalTutorial: Bool = false
    var showCloseButton = true
    
    //MARK: Custom component
    var pageViewController: CustomPageViewController?
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
        if segue.destination is CustomPageViewController{
            pageViewController = segue.destination as? CustomPageViewController
            pageViewController?.fromSettings = fromSettings
            pageViewController?.customFinalAction = customFinalAction
            pageViewController?.isFinalTutorial = isFinalTutorial
            pageViewController?.navigateLeftButton = navigateLeftButton
            pageViewController?.navigateRightButton = navigateRightButton
        }
    }
    
    // MARK: - Configuration
    private func configure(){
        self.view.backgroundColor = .backgroundColor
        
        //buttons
        closeButton.setTitle("", for: .normal)
        navigateRightButton.setTitle("", for: .normal)
        navigateLeftButton.setTitle("", for: .normal)
        navigateLeftButton.setImage(navigateLeftButton.image(for: .normal)?.withTintColor(.componentColor.disabled()), for: .normal)
        
        pageControlContainerView.layer.cornerRadius = 12.5
        pageControl.layer.cornerRadius = 12.5
        pageControl.backgroundStyle = .minimal
        pageControl.numberOfPages = model?.pageModels.count ?? 0
        pageViewController?.pageControl = self.pageControl
        
        if !showCloseButton{
            closeButton.isHidden = true
            closeButton.isEnabled = false
        }
    }
    
    private func configureModel(){
        guard let model = self.model else { return }
        pageViewController?.model = model
        pageViewController?.fromSettings = fromSettings
        pageViewController?.customFinalAction = customFinalAction
        pageViewController?.isFinalTutorial = isFinalTutorial
    }
    
    
    // MARK: - Events
    @IBAction func closeButtonEvent(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
