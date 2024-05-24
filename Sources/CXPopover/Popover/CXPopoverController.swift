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
    public let popoverBehavior: CXPopoverBehavior
    public let content: PopoverContent?
    
    // MARK: - Private properties
    
    private lazy var layoutProvider = DefaultLayoutProvider()
    
    // MARK: - Initializers
    
    public convenience init(popoverBehavior: CXPopoverBehavior = .default) {
        self.init(content: nil, popoverBehavior: popoverBehavior)
    }
    
    public init(content: PopoverContent?, popoverBehavior: CXPopoverBehavior = .default) {
        self.content = content
        self.popoverBehavior = popoverBehavior
        self.interactiveCoordinator = CXPopoverInteractiveCoordinator(behavior: popoverBehavior)
        
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
                anchor: popoverBehavior.anchor,
                ignoreSafeArea: false,
                layoutProvider: content ?? layoutProvider)
        }
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
        CXPopoverHelper.stylizePopover(view, behavior: popoverBehavior)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension CXPopoverController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, 
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        CXPopoverPresentationController(presented: presented,
                                        presenting: presenting,
                                        behavior: popoverBehavior,
                                        layoutProvider: content ?? layoutProvider)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        CXPopoverAnimationResolver.resolveAnimator(metadata: popoverBehavior.animationMetadata, isPresenting: true)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        CXPopoverAnimationResolver.resolveAnimator(metadata: popoverBehavior.animationMetadata, isPresenting: false)
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
