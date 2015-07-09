//
//  MyCardsPageViewController.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/8/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit
import Parse

class MyCardsViewController: UIViewController, UIPageViewControllerDataSource
{

    //
    // MARK: - Constants
    //
    
    private struct StoryboardIdentifier
    {
        static let CardNavController = "CardNavController"
        static let MyCardsPageViewController = "MyCardsPageViewController"
        static let NewCardNavController = "NewCardNavController"
    }
    
    //
    // MARK: - Properties
    //
    
    private var cardInstances = [CardInstance]()
    
    private var pageViewController: UIPageViewController!
    
    //
    // MARK: Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        pageViewController = storyboard!.instantiateViewControllerWithIdentifier(StoryboardIdentifier.MyCardsPageViewController) as! UIPageViewController
        
        pageViewController.dataSource = self
        
        addChildViewController(pageViewController)

        view.addSubview(pageViewController.view)

        // TODO: present a "loading..." message
        pageViewController.setViewControllers([UIViewController()], direction: .Forward, animated: true, completion: nil)
        
        pageViewController.didMoveToParentViewController(self)
        
        // get the data
        // TODO: move all the data stuff into a model class
        CardInstance.query(user: PFUser.currentUser()!).findObjectsInBackgroundWithBlock { (results, error) in
            if results != nil && !results!.isEmpty {
                self.cardInstances = results as! [CardInstance]
                println("set card instances")
                self.pageViewController.setViewControllers([self.makeViewController(cardInstance: self.cardInstances[0])], direction: .Forward, animated: true, completion: nil)
                println("set view controller view")
            } else {
                self.pageViewController.setViewControllers([self.storyboard?.instantiateViewControllerWithIdentifier(StoryboardIdentifier.NewCardNavController) as! UIViewController], direction: .Forward, animated: true, completion: nil)
            }
        }
    }
    
    private func getViewController(index: Int) -> UIViewController {
        return storyboard!.instantiateViewControllerWithIdentifier(StoryboardIdentifier.CardNavController) as! UIViewController
    }

    //
    // MARK: - UIPageViewControllerDatasource
    //
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        println("entering beforeVC")
        for var i = 0; i < cardInstances.count - 1; i++ {
            let curNavController = viewController as! UINavigationController
            let curCardController = curNavController.visibleViewController as! CardViewController
            if cardInstances[i + 1] == curCardController.cardInstance {
                return makeViewController(cardInstance: cardInstances[i])
            }
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        println("entering afterVC")
        for var i = 1; i < cardInstances.count; i++ {
            let curNavController = viewController as! UINavigationController
            let curCardController = curNavController.visibleViewController as! CardViewController
            if cardInstances[i - 1] == curCardController.cardInstance {
                return makeViewController(cardInstance: cardInstances[i])
            }
        }
        return nil
    }
    
    private func makeViewController(#cardInstance: CardInstance) -> UIViewController {
        let navViewController = storyboard!.instantiateViewControllerWithIdentifier(StoryboardIdentifier.CardNavController) as! UINavigationController
        let cardViewController = navViewController.visibleViewController as! CardViewController
        cardViewController.cardInstance = cardInstance
        return navViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return cardInstances.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //
    // MARK: - UIPageViewControllerDelegate
    //
    
}
