//
//  CXPopoverContentViewRepresentable.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/24/24.
//

import UIKit

public protocol CXPopoverContentViewRepresentable: UIView, CXPopoverLayoutProvider {
    func dismissPopover(animated: Bool)
}

public extension CXPopoverContentViewRepresentable {
    func dismissPopover(animated: Bool) {
        parentPopover?.dismiss(animated: animated)
    }
}

extension UIResponder {
    // https://stackoverflow.com/a/49714358/24016318
    var parentPopover: (any CXPopoverContentViewControllerRepresentable)? {
        next as? CXPopoverContentViewControllerRepresentable ?? next?.parentPopover
    }
}
