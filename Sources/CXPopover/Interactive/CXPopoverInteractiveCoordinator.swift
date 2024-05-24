//
//  CXPopoverInteractiveCoordinator.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/23/24.
//

import UIKit

public class CXPopoverInteractiveCoordinator {
    
    // MARK: - Internal properties
    
    weak var popoverController: CXPopoverController?
    
    // MARK: - Private properties
    
    private let interactiveAnimationMode: CXPresentationBehavior.InteractiveAnimationMode
    private let isInteractiveAnimationEffect: Bool
    
    private var dismissalTransition: CXPopoverInteractiveTransition?
    private var presentationTransition: CXPopoverInteractiveTransition?
    
    // MARK: - Initializer
    
    init(behavior: CXPresentationBehavior) {
        self.interactiveAnimationMode = behavior.interactiveAnimationMode
        self.isInteractiveAnimationEffect = Self.isAnimationEffectSupportInteracting(effect: behavior.animationMetadata.effect)
    }
    
    // MARK: - Public methods
    
    public func preparePresentingTransition(_ presentingViewController: UIViewController) {
        guard interactiveAnimationMode == .both,
              isInteractiveAnimationEffect,
              let popoverController else {
            return
        }
        
        let edge = popoverController.presentationBehavior.animationMetadata.moveIn
        let presentationTransition = PresentationTransition(
            presenting: presentingViewController,
            presented: popoverController,
            edge: edge)
        presentationTransition.prepare()
        
        self.presentationTransition = presentationTransition
    }
    
    // MARK: - Internal methods
    
    func prepareDismissalTransition() {
        guard interactiveAnimationMode != .none,
              isInteractiveAnimationEffect,
              let popoverController else {
            return
        }
        
        let edge = popoverController.presentationBehavior.animationMetadata.moveOut
        let dismissalTransition = DismissalTransition(presented: popoverController, edge: edge)
        dismissalTransition.prepare()
        
        self.dismissalTransition = dismissalTransition
    }
    
    func interactiveAnimatorForDismissal() -> (any UIViewControllerInteractiveTransitioning)? {
        guard interactiveAnimationMode != .none,
              let dismissalTransition else {
            return nil
        }
        return dismissalTransition.isInteracting ? dismissalTransition : nil
    }
    
    func interactiveAnimatorForPresentation() -> (any UIViewControllerInteractiveTransitioning)? {
        guard interactiveAnimationMode == .both,
              let presentationTransition else {
            return nil
        }
        return presentationTransition.isInteracting ? presentationTransition : nil
    }
    
    // MARK: - Private methods
    
    private static func isAnimationEffectSupportInteracting(effect: CXAnimationMetadata.AnimationEffect) -> Bool {
        switch effect {
        case .slide:
            return true
        default:
            return false
        }
    }
}

// MARK: - Dismissal transiton

extension CXPopoverInteractiveCoordinator {
    class DismissalTransition: CXPopoverBaseInteractiveTransition {
        
        // MARK: - Initializer
        
        init(presented: UIViewController, edge: CXAnimationMetadata.Edge) {
            super.init(edge: edge)
            self.presentedViewController = presented
        }
        
        // MARK: - Internal methods
        
        override func prepare() {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            presentedViewController?.view.addGestureRecognizer(panGesture)
        }
        
        // MARK: - Private methods
        
        @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            guard let view = gesture.view else {
                return
            }
            
            let translation = gesture.translation(in: view)
            let progress = makeProgress(translation, size: view.frame.size)
            
            switch gesture.state {
            case .began:
                isInteracting = true
                presentedViewController?.dismiss(animated: true)
            case .changed:
                update(progress)
            case .ended:
                progress <= Self.threshold ? cancel() : finish()
                isInteracting = false
            default:
                cancel()
                isInteracting = false
            }
        }
        
        private func makeProgress(_ translation: CGPoint, size: CGSize) -> CGFloat {
            switch edge {
            case .top:
                return translation.y >= 0 ? 0 : ((-translation.y * Self.multiplier) / size.height)
            case .left:
                return translation.x >= 0 ? 0 : ((-translation.x * Self.multiplier) / size.width)
            case .bottom:
                return translation.y <= 0 ? 0 : ((translation.y * Self.multiplier) / size.height)
            case .right:
                return translation.x <= 0 ? 0 : ((translation.x * Self.multiplier) / size.width)
            case .center:
                return 0
            }
        }
    }
}

// MARK: - Presentation transiton

extension CXPopoverInteractiveCoordinator {
    class PresentationTransition: CXPopoverBaseInteractiveTransition {
        
        // MARK: - Initializer
        
        init(presenting: UIViewController, presented: UIViewController, edge: CXAnimationMetadata.Edge) {
            super.init(edge: edge)
            self.presentingViewController = presenting
            self.presentedViewController = presented
        }
        
        // MARK: - Internal methods
        
        override func prepare() {
            let panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            panGesture.edges = makeEdges()
            presentingViewController?.view.addGestureRecognizer(panGesture)
        }
        
        // MARK: - Private methods
        
        @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            guard let view = gesture.view,
                  let presentingViewController,
                  let presentedViewController else {
                return
            }
            
            let translation = gesture.translation(in: view)
            let progress = makeProgress(translation, size: view.frame.size)
            
            switch gesture.state {
            case .began:
                isInteracting = true
                presentingViewController.present(presentedViewController, animated: true)
            case .changed:
                update(progress)
            case .ended:
                progress <= Self.threshold ? cancel() : finish()
                isInteracting = false
            default:
                cancel()
                isInteracting = false
            }
        }
        
        private func makeEdges() -> UIRectEdge {
            switch edge {
            case .top:
                return .top
            case .left:
                return .left
            case .bottom:
                return .bottom
            case .right:
                return .right
            case .center:
                return []
            }
        }
        
        private func makeProgress(_ translation: CGPoint, size: CGSize) -> CGFloat {
            switch edge {
            case .top:
                return translation.y <= 0 ? 0 : ((translation.y * Self.multiplier) / size.height)
            case .left:
                return translation.x <= 0 ? 0 : ((translation.x * Self.multiplier) / size.width)
            case .bottom:
                return translation.y >= 0 ? 0 : ((-translation.y * Self.multiplier) / size.height)
            case .right:
                return translation.x >= 0 ? 0 : ((-translation.x * Self.multiplier) / size.width)
            case .center:
                return 0
            }
        }
    }
}
