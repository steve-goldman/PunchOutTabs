//
//  CardBoxViewManager.swift
//  PunchOutTabs
//
//  Created by Steve Goldman on 6/27/15.
//  Copyright (c) 2015 Steve Goldman. All rights reserved.
//

import UIKit

class CardBoxContainerView: UIView {
    
    var deltas = [CGPoint]()
    
    var size = CGSize()
    
    private init(parentView: UIView, viewCount: Int, initializer: () -> UIView) {
        super.init(frame: CGRectZero)
        
        for index in 1...viewCount {
            addSubview(initializer())
            deltas.append(CGPointZero)
        }
        
        parentView.addSubview(self)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // subclasses MUST override this
    func recomputeDeltasAndSize() {
    }
    
    override func layoutSubviews() {
        recomputeDeltasAndSize()
        var curPoint = CGPointZero
        for index in 0..<subviews.count {
            curPoint = curPoint.shift(deltas[index])
            (subviews[index] as! UIView).frame = CGRect(origin: curPoint, size: size)
        }
    }
    
    func update(#frame: CGRect) {
        self.frame = frame
    }
    
    var numCardBoxes: Int {
        return subviews.count
    }
}

class TwoByTwoCardBoxViewManager: CardBoxContainerView
{
    static let NumBoxes = 4
    
    private let vertBuffer: CGFloat
    private let horizBuffer: CGFloat
    private let forceSquare: Bool
    
    init(parentView: UIView, vertBuffer: CGFloat = 0.05, horizBuffer: CGFloat = 0.05, forceSquare: Bool = false, initializer: () -> UIView) {
        self.vertBuffer = vertBuffer
        self.horizBuffer = horizBuffer
        self.forceSquare = forceSquare
        super.init(parentView: parentView, viewCount: TwoByTwoCardBoxViewManager.NumBoxes, initializer: initializer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func recomputeDeltasAndSize() {
        super.recomputeDeltasAndSize()
        
        let buffer = CGSize(width: horizBuffer * frame.width, height: vertBuffer * frame.height)
        
        let width = (frame.width - 3 * buffer.width) / 2
        let height = (frame.height - 3 * buffer.height) / 2
        let minDim = min(width, height)
        
        size = forceSquare ? CGSize(width: minDim, height: minDim) : CGSize(width: width, height: height)
        
        // working clockwise
        deltas = [
            CGPoint(x: frame.width / 2 - buffer.width / 2 - size.width, y: frame.height / 2 - buffer.height / 2 - size.height),
            CGPoint(x: size.width + buffer.width, y: 0),
            CGPoint(x: 0, y: size.height + buffer.height),
            CGPoint(x: -size.width - buffer.width, y: 0)
        ]
    }
    
}

class MultipleCardBoxContainerViewManager
{
    let cardBoxContainers: [CardBoxContainerView]
    
    init(cardBoxContainers: [CardBoxContainerView]) {
        self.cardBoxContainers = cardBoxContainers
    }
    
    func update(#index: Int, frame: CGRect) {
        cardBoxContainers[index].update(frame: frame)
    }
    
}

class TwoTwoByTwoCardBoxViewManager: MultipleCardBoxContainerViewManager
{
    static let NumBoxes = 8
    
    init(parentView: UIView, vertBuffer: CGFloat = 0.05, horizBuffer: CGFloat = 0.05, forceSquare: Bool = false, initializer: () -> UIView) {
        super.init(cardBoxContainers: [
            TwoByTwoCardBoxViewManager(parentView: parentView, vertBuffer: vertBuffer, horizBuffer: horizBuffer, forceSquare: forceSquare, initializer: initializer),
            TwoByTwoCardBoxViewManager(parentView: parentView, vertBuffer: vertBuffer, horizBuffer: horizBuffer, forceSquare: forceSquare, initializer: initializer) ])
    }

}

extension CGPoint {
    func shift(delta: CGPoint) -> CGPoint {
        return CGPoint(x: x + delta.x, y: y + delta.y)
    }
}
