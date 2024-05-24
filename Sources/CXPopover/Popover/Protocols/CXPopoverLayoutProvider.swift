//
//  CXPopoverLayoutProvider.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

public protocol CXPopoverLayoutProvider: AnyObject {
    func popover(sizeForPopover containerSize: CGSize, safeAreaInsets: UIEdgeInsets) -> CGSize
}

// MARK: - Default implementation

final class DefaultLayoutProvider: CXPopoverLayoutProvider {
    func popover(sizeForPopover containerSize: CGSize, safeAreaInsets: UIEdgeInsets) -> CGSize {
        CGSize(width: 300, height: 300)
    }
}
