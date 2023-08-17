//
//  GenericTutorialPageViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 05/08/23.
//

import UIKit

protocol GenericTutorialPageViewControllerDelegate{
    func genericTutorialPageViewController(isShowing viewController: UIViewController, atIndex index: Int)
}

class GenericTutorialPageViewController: UIPageViewController {
    
    // MARK: - Models
    var model: TutorialModel?{
        didSet{
            configureModel()
        }
    }
    var modelControllers: [UIViewController]?
    var pageControl: UIPageControl?
    var fromSettings: Bool = false
    var customFinalAction: (() -> Void)?
    var isFinalTutorial: Bool = false
    
    var customDelegate: GenericTutorialPageViewControllerDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureModel()
    }
    
    // MARK: - Configuration
    private func configure(){
        dataSource = self
        delegate = self
    }
    
    private func configureModel(){
        guard let model = self.model else { return }
        modelControllers = model.getControllers(fromSettings: fromSettings, finalAction: customFinalAction, isFinalTutorial: isFinalTutorial)
        guard let modelControllers = self.modelControllers else { return }
        
        setViewControllers([modelControllers[0]], direction: .forward, animated: true)
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
        self.customDelegate?.genericTutorialPageViewController(isShowing: pageContentViewC, atIndex: pageControl.currentPage)
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

extension GenericTutorialPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
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
