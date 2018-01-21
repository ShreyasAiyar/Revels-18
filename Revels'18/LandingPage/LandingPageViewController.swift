//
//  LandingPageViewController.swift
//  Revels'18
//
//  Created by Shreyas Aiyar on 30/11/17.
//  Copyright © 2017 Shreyas Aiyar. All rights reserved.
//

import UIKit

class LandingPageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    lazy var viewControllerList:[UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let page1 = storyboard.instantiateViewController(withIdentifier:"PageOne")
        let page2 = storyboard.instantiateViewController(withIdentifier:"PageTwo")
        let page3 = storyboard.instantiateViewController(withIdentifier:"PageThree")
        return [page1,page2,page3]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstViewController = viewControllerList.first{
        self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
        guard viewControllerList.count > previousIndex else {return nil}
        
        
        return viewControllerList[previousIndex]

    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else {return nil}
        
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        let currentIndex = viewControllerList.index(of:pageViewController)
        return currentIndex!
    }

}
