//
//  CXPopoverController.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

public class CXPopoverController: UIViewController {
    public typealias OnComplete = () -> Void
    
    // MARK: - Public properties
    
    public let interactiveCoordinator: CXPopoverInteractiveCoordinator
    public let behavior: CXPopoverBehavior
    
    // MARK: - Private properties
    
    private let contentViewController: (any CXPopoverContentViewControllerRepresentable)?
    
    private lazy var layoutProvider = DefaultLayoutProvider()
    
    // MARK: - Initializers
    
    public convenience init(behavior: CXPopoverBehavior = .default) {
        self.init(contentViewController: nil, behavior: behavior)
    }
    
    public convenience init(contentView: any CXPopoverContentViewRepresentable, behavior: CXPopoverBehavior = .default) {
        self.init(contentViewController: PopoverContentViewWrapper(contentView: contentView), behavior: behavior)
    }
    
    public init(contentViewController: (any CXPopoverContentViewControllerRepresentable)?, behavior: CXPopoverBehavior = .default) {
        self.contentViewController = contentViewController
        self.behavior = behavior
        self.interactiveCoordinator = CXPopoverInteractiveCoordinator(behavior: behavior)
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        self.interactiveCoordinator.popoverController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupContentIfNeeded()
        stylize()
        
        interactiveCoordinator.prepareDismissalTransition()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { [unowned self] _ in
            // https://stackoverflow.com/a/46581783/24016318
            let safeAreaInsets = presentingViewController?.view.safeAreaInsets ?? .zero
            
            view.frame = CXPopoverHelper.makePopoverFrame(
                containerSize: size,
                safeAreaInsets: safeAreaInsets,
                anchor: behavior.anchor,
                ignoreSafeArea: false,
                layoutProvider: contentViewController ?? layoutProvider)
        }
    }
    
    // MARK: - Private methods
    
    private func setupContentIfNeeded() {
        guard let contentViewController else {
            return
        }
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        contentViewController.didMove(toParent: self)
    }
    
    private func stylize() {
        view.backgroundColor = behavior.popoverBackgroundColor
        CXPopoverHelper.stylizePopover(view, behavior: behavior)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension CXPopoverController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        CXPopoverPresentationController(presented: presented,
                                        presenting: presenting,
                                        behavior: behavior,
                                        layoutProvider: contentViewController ?? layoutProvider)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        CXPopoverAnimationResolver.resolveAnimator(metadata: behavior.animationMetadata, isPresenting: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        CXPopoverAnimationResolver.resolveAnimator(metadata: behavior.animationMetadata, isPresenting: false)
    }
    
    public func interactionControllerForDismissal(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        interactiveCoordinator.interactiveAnimatorForDismissal()
    }
    
    public func interactionControllerForPresentation(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        interactiveCoordinator.interactiveAnimatorForPresentation()
    }
}

// MARK: - PopoverContentViewWrapper

extension CXPopoverController {
    final class PopoverContentViewWrapper: UIViewController, CXPopoverContentViewControllerRepresentable {
        
        // MARK: - Private properties
        
        private let contentView: any CXPopoverContentViewRepresentable
        
        // MARK: - Initializer
        
        init(contentView: any CXPopoverContentViewRepresentable) {
            self.contentView = contentView
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func loadView() {
            self.view = contentView
        }
        
        func popover(sizeForPopover containerSize: CGSize, safeAreaInsets: UIEdgeInsets) -> CGSize {
            contentView.popover(sizeForPopover: containerSize, safeAreaInsets: safeAreaInsets)
        }
    }
}
