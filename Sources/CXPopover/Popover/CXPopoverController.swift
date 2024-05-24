//
//  CXPopoverController.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

public class CXPopoverController: UIViewController {
    public typealias PopoverContent = UIViewController & CXPopoverLayoutProvider
    public typealias OnComplete = () -> Void
    
    // MARK: - Public properties
    
    public let interactiveCoordinator: CXPopoverInteractiveCoordinator
    public let presentationBehavior: CXPresentationBehavior
    public let content: PopoverContent?
    
    // MARK: - Private properties
    
    private lazy var layoutProvider = DefaultLayoutProvider()
    
    // MARK: - Initializers
    
    public convenience init(presentationBehavior: CXPresentationBehavior = .default) {
        self.init(content: nil, presentationBehavior: presentationBehavior)
    }
    
    public init(content: PopoverContent?, presentationBehavior: CXPresentationBehavior = .default) {
        self.content = content
        self.presentationBehavior = presentationBehavior
        self.interactiveCoordinator = CXPopoverInteractiveCoordinator(behavior: presentationBehavior)
        
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
    
    // MARK: - Private methods
    
    private func setupContentIfNeeded() {
        guard let content else {
            return
        }
        addChild(content)
        view.addSubview(content.view)
        content.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            content.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.view.topAnchor.constraint(equalTo: view.topAnchor),
            content.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        content.didMove(toParent: self)
    }
    
    private func stylize() {
        view.backgroundColor = .systemBackground
        CXPopoverHelper.stylizePopover(view, behavior: presentationBehavior)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension CXPopoverController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, 
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        CXPopoverPresentationController(presented: presented,
                                        presenting: presenting,
                                        behavior: presentationBehavior,
                                        layoutProvider: content ?? layoutProvider)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        CXPopoverAnimationResolver.resolveAnimator(metadata: presentationBehavior.animationMetadata, isPresenting: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        CXPopoverAnimationResolver.resolveAnimator(metadata: presentationBehavior.animationMetadata, isPresenting: false)
    }
    
    public func interactionControllerForDismissal(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        interactiveCoordinator.interactiveAnimatorForDismissal()
    }
    
    public func interactionControllerForPresentation(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        interactiveCoordinator.interactiveAnimatorForPresentation()
    }
}

// MARK: - UIViewController extensions

public extension UIViewController {
    func prepareInteractivePopoverPresentation(of popover: CXPopoverController) {
    }
}
