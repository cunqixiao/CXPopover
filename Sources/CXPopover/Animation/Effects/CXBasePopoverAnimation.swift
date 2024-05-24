//
//  CXBasePopoverAnimation.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

class CXBasePopoverAnimation: CXPopoverAnimationCoordinator {
    
    // MARK: - Public Properties
    
    public let duration: TimeInterval
    
    public let options: UIView.AnimationOptions
    
    public let isPresenting: Bool
    
    // MARK: - Initialier
    
    public init(duration: TimeInterval, options: UIView.AnimationOptions, isPresenting: Bool) {
        self.duration = duration
        self.options = options
        self.isPresenting = isPresenting
    }
    
    public func setup(context: any UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController) {
        if isPresenting, toVC.view.superview == nil {
            context.containerView.addSubview(toVC.view)
        }
        toVC.view.frame = context.finalFrame(for: toVC)
    }
    
    public func update(context: any UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController) {
        fatalError("update(context:from:to:) has not been implemented")
    }
    
    public final func combine(with animation: CXBasePopoverAnimation) -> CXBasePopoverAnimation {
        return CXComplexPopoverAnimation(
            animations: [self, animation], 
            duration: animation.duration,
            options: animation.options,
            isPresenting: animation.isPresenting)
    }
}
