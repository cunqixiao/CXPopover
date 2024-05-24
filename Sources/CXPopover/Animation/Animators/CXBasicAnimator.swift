//
//  CXBasicAnimator.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

public class CXBasicAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Public properties

    public let animation: any CXPopoverAnimationCoordinator

    // MARK: - Initializers

    public init(animation: any CXPopoverAnimationCoordinator) {
        self.animation = animation
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
        
        let onComplete = { [animation] in
            animation.cleanup(context: transitionContext, from: fromVC, to: toVC)
        }
        
        UIView.animate(
            withDuration: animation.duration,
            delay: .zero,
            options: animation.options) { [unowned self] in
            animation.update(context: transitionContext, from: fromVC, to: toVC)
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            onComplete()
        }
    }
}
