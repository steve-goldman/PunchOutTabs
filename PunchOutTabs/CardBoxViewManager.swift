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

class MbyNCardBoxViewManager: CardBoxContainerView
{
    private let m: Int
    private let n: Int
    private let vertBuffer: CGFloat
    private let horizBuffer: CGFloat
    private let forceSquare: Bool
    
    init(m: Int, n: Int, parentView: UIView, vertBuffer: CGFloat = 0.05, horizBuffer: CGFloat = 0.05, forceSquare: Bool = false, initializer: () -> UIView) {
        self.m = m
        self.n = n
        self.vertBuffer = vertBuffer
        self.horizBuffer = horizBuffer
        self.forceSquare = forceSquare
        super.init(parentView: parentView, viewCount: m * n, initializer: initializer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func startingOffset(#dim: Int, frameDim: CGFloat, sizeDim: CGFloat, bufferDim: CGFloat) -> CGFloat {
        var offset = (frameDim / 2)
        if dim > 2 {
            for _ in 1...((dim - 1) / 2) {
                offset = offset.advancedBy(-bufferDim)
            }
        }
        if dim % 2 == 0 {
            offset = offset.advancedBy(-bufferDim / 2)
        }
        
        if dim > 1 {
            for _ in 1...(dim / 2) {
                offset = offset.advancedBy(-sizeDim)
            }
        }
        if dim % 2 == 1 {
            offset = offset.advancedBy(-sizeDim / 2)
        }

        return offset
    }

    override func recomputeDeltasAndSize() {
        super.recomputeDeltasAndSize()
        
        let buffer = CGSize(width: horizBuffer * frame.width, height: vertBuffer * frame.height)
        
        let width = (frame.width - CGFloat(m + 1) * buffer.width) / CGFloat(m)
        let height = (frame.height - CGFloat(n + 1) * buffer.height) / CGFloat(n)
        let minDim = min(width, height)
        
        size = forceSquare ? CGSize(width: minDim, height: minDim) : CGSize(width: width, height: height)
        
        // working clockwise
        deltas = [CGPoint]()
        
        deltas.append(CGPoint(x: MbyNCardBoxViewManager.startingOffset(dim: m, frameDim: frame.width, sizeDim: size.width, bufferDim: buffer.width), y: MbyNCardBoxViewManager.startingOffset(dim: n, frameDim: frame.height, sizeDim: size.height, bufferDim: buffer.height)))
        
        // by column
        for column in 1...n {
            // by row
            if m > 1 {
                for _ in 1...(m - 1) {
                    deltas.append(CGPoint(x: (column % 2 == 1 ? 1 : -1) * (size.width + buffer.width), y: 0))
                }
            }
            if column != n {
                deltas.append(CGPoint(x: 0, y: size.height + buffer.height))
            }
        }

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
    static let NumBoxes = 13
    
    init(parentView: UIView, vertBuffer: CGFloat = 0.05, horizBuffer: CGFloat = 0.05, forceSquare: Bool = false, initializer: () -> UIView) {
        super.init(cardBoxContainers: [
            MbyNCardBoxViewManager(m: 2, n: 2, parentView: parentView, vertBuffer: vertBuffer, horizBuffer: horizBuffer, forceSquare: forceSquare, initializer: initializer),
            MbyNCardBoxViewManager(m: 3, n: 3, parentView: parentView, vertBuffer: vertBuffer, horizBuffer: horizBuffer, forceSquare: forceSquare, initializer: initializer) ])
    }

}

extension CGPoint {
    func shift(delta: CGPoint) -> CGPoint {
        return CGPoint(x: x + delta.x, y: y + delta.y)
    }
}
