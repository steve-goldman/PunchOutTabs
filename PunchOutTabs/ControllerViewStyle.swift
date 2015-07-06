//
//  ControllerStyling.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 7/6/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit

public struct ControllerViewStyleParams
{

    let backgroundImageName: String?
    let backgroundImageAlpha: CGFloat
    let backgroundColor: UIColor?

    private struct Defaults
    {
        static let BackgroundImageAlpha = CGFloat(0.35)
        static let BackgroundColor = UIColor.lightGrayColor()
    }
    
    init(backgroundImageName: String?, backgroundImageAlpha: CGFloat = Defaults.BackgroundImageAlpha, backgroundColor: UIColor? = Defaults.BackgroundColor) {
        self.backgroundImageName = backgroundImageName
        self.backgroundImageAlpha = backgroundImageAlpha
        self.backgroundColor = backgroundColor
    }
    
}


public class ControllerViewStyle
{
    
    // MARK: - Constants
    
    public static let LoginParams = ControllerViewStyleParams(backgroundImageName: "bg_planking")
    public static let SignUpParams = ControllerViewStyleParams(backgroundImageName: "bg_smiling")
    public static let ForgotPasswordParams = ControllerViewStyleParams(backgroundImageName: "bg_upright")
    public static let PunchItParams = ControllerViewStyleParams(backgroundImageName: "bg_upright2")
    public static let SettingsParams = ControllerViewStyleParams(backgroundImageName: "bg_upright")
    
    // MARK: - Properties
    
    private let viewController: UIViewController
    private var backgroundImageView: UIImageView?
    
    // MARK: - Initializers
    
    init(viewController: UIViewController, params: ControllerViewStyleParams) {

        if params.backgroundImageName != nil {
            let backgroundImage = UIImage(named: params.backgroundImageName!)
            backgroundImageView = UIImageView(image: backgroundImage)
            backgroundImageView!.alpha = params.backgroundImageAlpha
            backgroundImageView!.contentMode = UIViewContentMode.ScaleAspectFill
            viewController.view.insertSubview(backgroundImageView!, atIndex: 0)
        }
        
        if params.backgroundColor != nil {
            viewController.view.backgroundColor = params.backgroundColor
        }
        
        self.viewController = viewController
    }
 
    // MARK: - Methods
    
    func layoutViews() {
        if backgroundImageView != nil {
            println(viewController.bottomLayoutGuide.length)
            backgroundImageView!.frame = CGRectMake(0, viewController.topLayoutGuide.length, viewController.view.frame.width, viewController.view.frame.height - viewController.bottomLayoutGuide.length - viewController.topLayoutGuide.length)
        }
    }

}
