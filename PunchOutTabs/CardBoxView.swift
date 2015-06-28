//
//  CardBoxView.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/26/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit

@IBDesignable
class CardBoxView: UIView {
    
    let index: Int
    
    private var path: UIBezierPath!
    
    var stamped = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    init(index: Int)
    {
        self.index = index
        super.init(frame: CGRectZero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func create(#index: Int) -> CardBoxView {
        let view = CardBoxView(index: index)
        view.backgroundColor = UIColor.clearColor()
        return view
    }

    override func drawRect(rect: CGRect) {
        
        path = UIBezierPath(ovalInRect: bounds.pinchedRect(pinch: CGFloat(2)))
        
        stamped ? UIColor.yellowColor().set() : UIColor.blueColor().set()
        
        path.fill()
        path.stroke()
    }
    
    func contains(point: CGPoint) -> Bool {
        return path.containsPoint(point)
    }

}

extension CGRect {
    
    func pinchedRect(#pinch: CGFloat) -> CGRect {
        return pinchedRect(pinchX: pinch, pinchY: pinch)
    }
    
    func pinchedRect(#pinchX: CGFloat, pinchY: CGFloat) -> CGRect {
        return CGRect(x: origin.x + pinchX, y: origin.y + pinchY, width: width - 2 * pinchX, height: height - 2 * pinchY)
    }

}
