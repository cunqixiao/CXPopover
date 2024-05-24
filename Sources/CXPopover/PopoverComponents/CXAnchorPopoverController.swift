//
//  CXAnchorPopoverController.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/24/24.
//

import UIKit

public class CXAnchorPopoverController: CXPopoverController {
    
    // MARK: - Initializers
    
    public convenience init(contentView: any CXPopoverContentViewRepresentable,
                            anchorFrame: CGRect,
                            insets: UIEdgeInsets,
                            preferredEdge: UIRectEdge,
                            behavior: CXPopoverBehavior) {
        let anchor: CXPopoverBehavior.Anchor = .anchor(frame: anchorFrame, insets: insets, preferredEdge: preferredEdge)
        self.init(contentView: contentView, anchor: anchor, behavior: behavior)
    }
    
    public init(contentView: any CXPopoverContentViewRepresentable, anchor: CXPopoverBehavior.Anchor, behavior: CXPopoverBehavior) {
        let anchorContainerView = AnchorContainerView(contentView: contentView, anchor: anchor, behavior: behavior)
        let wrapper = PopoverContentViewWrapper(contentView: anchorContainerView)
        super.init(contentViewController: wrapper, behavior: anchorContainerView.behavior)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// For popover, we simply hide the popover when the view controller is about to rotate, this can help to avoid
    /// tons of layout calculation. :), and it shouldn't affect user experience significantly.
    public override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        dismiss(animated: true)
    }
}

// MARK: - UIView extensions for presenting anchored popover

public extension UIView {
    func present(_ contentView: any CXPopoverContentViewRepresentable,
                 preferredEdge: UIRectEdge,
                 insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
                 behavior: CXPopoverBehavior = .default,
                 animated: Bool = true) {
        let anchor = CXPopoverBehavior.Anchor.anchor(frame: frame, insets: insets, preferredEdge: preferredEdge)
        let anchorPopover = CXAnchorPopoverController(contentView: contentView, anchor: anchor, behavior: behavior)
        parentViewController?.present(anchorPopover, animated: animated)
    }
}

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
