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
        
        return CXPopoverHelper.makePopoverFrame(
            containerSize: containerView.frame.size,
            safeAreaInsets: containerView.safeAreaInsets,
            anchor: popoverBehavior.anchor,
            ignoreSafeArea: popoverBehavior.ignoreSafeArea,
            layoutProvider: layoutProvider)
    }
    
    // MARK: - Private properties
    
    private let popoverBehavior: CXPopoverBehavior
    private weak var layoutProvider: (any CXPopoverLayoutProvider)?
    
    private var coordinator: (any UIViewControllerTransitionCoordinator)? {
        presentedViewController.transitionCoordinator
    }
    
    private lazy var backgroundMask: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = popoverBehavior.backgroundColor
        view.alpha = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundMask)))
        return view
    }()
    
    // MARK: - Initializer
    
    init(presented: UIViewController, presenting: UIViewController?, behavior: CXPopoverBehavior, layoutProvider: any CXPopoverLayoutProvider) {
        self.popoverBehavior = behavior
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
        guard !popoverBehavior.isModal else { 
            return
        }
        presentedViewController.dismiss(animated: true)
    }
}
