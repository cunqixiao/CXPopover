//
//  CXPopoverPresentationController.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

final class CXPopoverPresentationController: UIPresentationController {
    
    // MARK: Override properties
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView else {
            return .zero
        }
        let contentSize = layoutProvider?.popover(sizeForPopover: containerView.frame.size, safeAreaInsets: containerView.safeAreaInsets) ?? .zero
        let insets: UIEdgeInsets = behavior.ignoreSafeArea ? .zero : containerView.safeAreaInsets
        let origin = CXPopoverHelper.makeOrigin(
            containerSize: containerView.frame.size,
            contentSize: contentSize,
            insets: insets,
            anchor: behavior.anchor)
        return CGRect(origin: origin, size: contentSize)
    }
    
    // MARK: - Private properties
    
    private let behavior: CXPresentationBehavior
    private weak var layoutProvider: (any CXPopoverLayoutProvider)?
    
    private var coordinator: (any UIViewControllerTransitionCoordinator)? {
        presentedViewController.transitionCoordinator
    }
    
    private lazy var backgroundMask: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = behavior.backgroundColor
        view.alpha = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundMask)))
        return view
    }()
    
    // MARK: - Initializer
    
    init(presented: UIViewController, presenting: UIViewController?, behavior: CXPresentationBehavior, layoutProvider: any CXPopoverLayoutProvider) {
        self.behavior = behavior
        self.layoutProvider = layoutProvider
        super.init(presentedViewController: presented, presenting: presenting)
    }
    
    // MARK: - Override methods
    
    override func presentationTransitionWillBegin() {
        guard let containerView else {
            super.presentationTransitionWillBegin()
            return
        }
        
        containerView.addSubview(backgroundMask)
        NSLayoutConstraint.activate([
            backgroundMask.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundMask.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundMask.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundMask.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        backgroundMask.alpha = 0
        coordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundMask.alpha = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        coordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundMask.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            backgroundMask.removeFromSuperview()
        }
    }
    
    // MARK: - Private methods
    
    @objc private func didTapBackgroundMask() {
        guard !behavior.isModal else { 
            return
        }
        presentedViewController.dismiss(animated: true)
    }
}
