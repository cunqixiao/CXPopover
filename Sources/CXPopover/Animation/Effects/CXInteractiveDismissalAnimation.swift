//
//  File.swift
//  
//
//  Created by Cunqi Xiao on 5/23/24.
//

import UIKit

final class CXInteractiveDismissalAnimation: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Constants
    
    private static let dismissalThreshold: CGFloat = 0.3
    private static let multiplier: CGFloat = 1
    
    // MARK: - Internal properties
    
    var isInteracting = false
    
    // MARK: - Private properties
    
    private let behavior: CXPresentationBehavior
    private weak var viewController: UIViewController?
    
    private var isInteractable: Bool {
        !behavior.animationMetadata.isInteractiveAnimationDisabled
    }
    
    // MARK: - Initializer
    
    init(viewController: UIViewController, behavior: CXPresentationBehavior) {
        self.behavior = behavior
        self.viewController = viewController
        super.init()
        prepareGestureRecognizer(in: viewController.view)
    }
    
    // MARK: - Private methods
    
    private func prepareGestureRecognizer(in view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard isInteractable, let view = gesture.view else {
            return
        }
        let translation = gesture.translation(in: view.superview)
        let progress = calculateProgress(with: translation, size: view.frame.size)
        switch gesture.state {
        case .began:
            isInteracting = true
            viewController?.dismiss(animated: true)
        case .changed:
            update(progress)
        case .ended:
            if progress <= Self.dismissalThreshold {
                cancel()
            } else {
                finish()
            }
            isInteracting = false
        default:
            cancel()
            isInteracting = false
        }
    }
    
    private func calculateProgress(with translation: CGPoint, size: CGSize) -> CGFloat {
        switch behavior.animationMetadata.moveOut {
        case .top:
            return translation.y >= .zero ? .zero : (-translation.y * Self.multiplier / size.height)
        case .left:
            return translation.x >= .zero ? .zero : (-translation.x * Self.multiplier / size.width)
        case .bottom:
            return translation.y < .zero ? .zero : (translation.y * Self.multiplier / size.height)
        case .right:
            return translation.x < .zero ? .zero : (translation.x * Self.multiplier / size.width)
        case .center:
            return .zero
        }
    }
}
