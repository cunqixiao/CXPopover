//
//  CXBounceAnimator.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

public class CXBounceAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Public properties
    
    public let animation: any CXPopoverAnimationCoordinator
    
    // MARK: - Private properties
    
    private let damping: CGFloat
    private let velocity: CGFloat
    
    // MARK: - Initializers
    
    public init(animation: any CXPopoverAnimationCoordinator, damping: CGFloat = 0.8, velocity: CGFloat = 0.5) {
        self.animation = animation
        self.damping = damping
        self.velocity = velocity
        super.init()
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animation.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        animation.setup(context: transitionContext, from: fromVC, to: toVC)
        
        UIView.animate(
            withDuration: animation.duration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: velocity) { [unowned self] in
                animation.update(context: transitionContext, from: fromVC, to: toVC)
            } completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
    }
}

