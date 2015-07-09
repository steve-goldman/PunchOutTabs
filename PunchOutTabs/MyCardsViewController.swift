//
//  MyCardsPageViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/8/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class MyCardsViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{

    //
    // MARK: - Constants
    //
    
    private struct StoryboardIdentifier
    {
        static let CardNavController = "CardNavController"
        static let NewCardNavController = "NewCardNavController"
    }
    
    //
    // MARK: - Properties
    //
    
    private var cardInstances = [CardInstance]() {
        didSet {
            pageControl.numberOfPages = cardInstances.count
            var index = 0
            self.cardViewControllers = cardInstances.map({ [unowned self] (cardInstance: CardInstance) -> UIViewController in
                let cardNavController = self.storyboard!.instantiateViewControllerWithIdentifier(StoryboardIdentifier.CardNavController) as! UINavigationController
                let cardViewController = cardNavController.visibleViewController as! CardViewController
                cardViewController.cardInstance = cardInstance
                cardViewController.index = index++
                return cardNavController
            })
        }
    }
    
    private var cardViewControllers = [UIViewController]()
    
    private var pageViewController: UIPageViewController!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    //
    // MARK: Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        addChildViewController(pageViewController)

        // use 'insert' so it appears behind the page control
        view.insertSubview(pageViewController.view, atIndex: 0)
        
        // TODO: present a "loading..." message
        //pageViewController.setViewControllers([UIViewController()], direction: .Forward, animated: true, completion: nil)
        
        pageViewController.didMoveToParentViewController(self)
        
        // get the data
        // TODO: move all the data stuff into a model class
        CardInstance.query(user: PFUser.currentUser()!).findObjectsInBackgroundWithBlock { (results, error) in
            if results != nil && !results!.isEmpty {
                self.cardInstances = results!.reverse() as! [CardInstance]
                self.pageViewController.setViewControllers([self.cardViewControllers[0]], direction: .Forward, animated: true, completion: nil)
            } else {
                self.pageViewController.setViewControllers([self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardIdentifier.NewCardNavController) as! UIViewController], direction: .Forward, animated: true, completion: nil)
            }
        }
    }

    //
    // MARK: - UIPageViewControllerDatasource
    //
    
    private var curIndex = 0
    private var nextIndex = -1
    
    private func getIndex(viewController: UIViewController) -> Int {
        let cardNavController = viewController as! UINavigationController
        let cardViewController = cardNavController.visibleViewController as! CardViewController
        return cardViewController.index
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = getIndex(viewController)
        if index == 0 {
            return nil
        } else {
            return cardViewControllers[index - 1]
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = getIndex(viewController)
        if index == cardViewControllers.count - 1 {
            return nil
        } else {
            return cardViewControllers[index + 1]
        }
    }
    
    //
    // MARK: - UIPageViewControllerDelegate
    //
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        nextIndex = getIndex(pendingViewControllers[0] as! UIViewController)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if (completed) {
            pageControl.currentPage = nextIndex
        }
    }
}
