//
//  CustomPageViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 03/09/23.
//

import UIKit


protocol CustomPageViewControllerDelegate{
    func customPageViewController(isShowing viewController: UIViewController, atIndex index: Int)
}

protocol ControllerAssociable{
    func getControllers(fromSettings: Bool, finalAction: (() -> Void)?, isFinal: Bool) -> [UIViewController] 
}

class CustomPageViewController: UIPageViewController {
    
    var modelControllers: [UIViewController]?
    var pageControl: UIPageControl?
    var navigateRightButton: UIButton!
    var navigateLeftButton: UIButton!
    var fromSettings: Bool = false
    var customFinalAction: (() -> Void)?
    var isFinalTutorial: Bool = false
    
    var customDelegate: CustomPageViewControllerDelegate?
    
    // MARK: - Models
    var model: ControllerAssociable?{
        didSet{
            configureModel()
        }
    }
    
    //MARK: - Custom initializer
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the delegates
        delegate = self
        dataSource = self
        customDelegate = self
    }
    
    // MARK: - Configuration
    private func configureModel(){
        guard let model = self.model else { return }
        modelControllers = model.getControllers(fromSettings: fromSettings, finalAction: customFinalAction, isFinal: isFinalTutorial)
        guard let modelControllers = self.modelControllers else { return }
        pageControl?.numberOfPages = modelControllers.count
        pageControl?.currentPage = 1
        
        setViewControllers([modelControllers[1]], direction: .forward, animated: true)
        customPageViewController(isShowing: modelControllers[1], atIndex: 1)
    }
    
    // MARK: - Private utilities
    private func getController(direction: Direction, viewController: UIViewController) -> UIViewController? {
        guard let modelControllers = self.modelControllers else { return nil }
        switch direction {
        case .after:
            guard let viewControllerIndex = modelControllers.firstIndex(of: viewController) else { return nil }
            
            let nextIndex = viewControllerIndex + 1
            guard nextIndex < modelControllers.count else { return nil }
            guard modelControllers.count > nextIndex else { return nil }
            
            return modelControllers[nextIndex]
        case .before:
            guard let viewControllerIndex = modelControllers.firstIndex(of: viewController) else { return nil }
            
            let previousIndex = viewControllerIndex - 1
            guard previousIndex >= 0          else { return nil }
            guard modelControllers.count > previousIndex else { return nil }
            
            return modelControllers[previousIndex]
        }
    }
    
    private func updatePageControl(){
        guard let pageControl = self.pageControl, let modelControllers = self.modelControllers else { return }
        let previousIndex = pageControl.currentPage
        let pageContentViewC = self.viewControllers![0]
        pageControl.currentPage = modelControllers.firstIndex(of: pageContentViewC)!
        self.customDelegate?.customPageViewController(isShowing: pageContentViewC, atIndex: pageControl.currentPage)
        if previousIndex == pageControl.currentPage { return }
    }
    
    // MARK: = Public utilities
    public func navigate(direction: Direction){
        guard let viewController = self.viewControllers?.first else { return }
        guard let newC = getController(direction: direction, viewController: viewController) else { return }
        self.setViewControllers([newC], direction: direction == .after ? .forward : .reverse, animated: true)
        updatePageControl()
    }
    
    // MARK: - Custom models
    enum Direction{
        case after
        case before
    }
}

extension CustomPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource, CustomPageViewControllerDelegate{
    func customPageViewController(isShowing viewController: UIViewController, atIndex index: Int) {
        if index == 0{
            //Disable the left
            navigateLeftButton.setImage(navigateLeftButton.image(for: .normal)?.withTintColor(.componentColor.disabled()), for: .normal)
        }else if index + 1 == modelControllers?.count{
            //Disable the right
            navigateRightButton.setImage(navigateRightButton.image(for: .normal)?.withTintColor(.componentColor.disabled()), for: .normal)
        }else{
            navigateLeftButton.setImage(navigateLeftButton.image(for: .normal)?.withTintColor(.componentColor), for: .normal)
            navigateRightButton.setImage(navigateRightButton.image(for: .normal)?.withTintColor(.componentColor), for: .normal)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getController(direction: .before, viewController: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getController(direction: .after, viewController: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        updatePageControl()
    }
}
