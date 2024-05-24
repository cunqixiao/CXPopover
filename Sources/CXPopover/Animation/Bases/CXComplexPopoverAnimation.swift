//
//  CXComplexPopoverAnimation.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

class CXComplexPopoverAnimation: CXBasePopoverAnimation {

    // MARK: - Public properties

    public let animations: [any CXPopoverAnimationCoordinator]

    // MARK: - Initializers

    public init(animations: [any CXPopoverAnimationCoordinator], duration: TimeInterval, options: UIView.AnimationOptions, isPresenting: Bool) {
        self.animations = animations
        super.init(duration: duration, options: options, isPresenting: isPresenting)
    }

    // MARK: - Override methods

    public override func setup(context: UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController) {
        super.setup(context: context, from: fromVC, to: toVC)
        
        let transformAnimations = animations.compactMap { $0 as? CXTransformAnimation }
        let baseAnimations = animations.filter { !($0 is CXTransformAnimation) }
        
        // Apply base animations
        baseAnimations.forEach { $0.setup(context: context, from: fromVC, to: toVC) }
        
        // Apply transform animations
        let view: UIView = isPresenting ? toVC.view : fromVC.view
        let transform = transformAnimations.reduce(CGAffineTransform.identity) { partialResult, animation in
            return partialResult.concatenating(animation.setupTransform(frame: view.frame))
        }
        view.transform = transform
    }

    public override func update(context: UIViewControllerContextTransitioning, from fromVC: UIViewController, to toVC: UIViewController) {
        let transformAnimations = animations.compactMap { $0 as? CXTransformAnimation }
        let baseAnimations = animations.filter { !($0 is CXTransformAnimation) }
        
        // Apply base animations
        baseAnimations.forEach { $0.update(context: context, from: fromVC, to: toVC) }
        
        // Apply transform animations
        let view: UIView = isPresenting ? toVC.view : fromVC.view
        let transform = transformAnimations.reduce(CGAffineTransform.identity) { partialResult, animation in
            return partialResult.concatenating(animation.updateTransform(frame: view.frame))
        }
        view.transform = transform
    }
}
