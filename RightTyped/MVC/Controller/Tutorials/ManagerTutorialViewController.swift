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
            pageViewController?.customDelegate = self
            pageViewController?.fromSettings = fromSettings
            pageViewController?.customFinalAction = customFinalAction
            pageViewController?.isFinalTutorial = isFinalTutorial
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
    
    @IBAction func navigateRightEvent(_ sender: Any) {
        pageViewController?.navigate(direction: .after)
    }
    
    @IBAction func navigateLeftEvent(_ sender: Any) {
        pageViewController?.navigate(direction: .before)
    }
}

extension ManagerTutorialViewController: GenericTutorialPageViewControllerDelegate{
    func genericTutorialPageViewController(isShowing viewController: UIViewController, atIndex index: Int) {
        if index == 0{
            //Disable the left
            navigateLeftButton.setImage(navigateLeftButton.image(for: .normal)?.withTintColor(.componentColor.disabled()), for: .normal)
        }else if index + 1 == model?.pageModels.count{
            //Disable the right
            navigateRightButton.setImage(navigateRightButton.image(for: .normal)?.withTintColor(.componentColor.disabled()), for: .normal)
        }else{
            navigateLeftButton.setImage(navigateLeftButton.image(for: .normal)?.withTintColor(.componentColor), for: .normal)
            navigateRightButton.setImage(navigateRightButton.image(for: .normal)?.withTintColor(.componentColor), for: .normal)
        }
    }
}
