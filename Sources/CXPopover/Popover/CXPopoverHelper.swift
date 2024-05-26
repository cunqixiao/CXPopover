//
//  CXPopoverHelper.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

class CXPopoverHelper {
    
    // MARK: - Static internal methods
    
    static func makePopoverFrame(containerSize: CGSize, 
                                 safeAreaInsets: UIEdgeInsets,
                                 anchor: CXPopoverBehavior.Anchor,
                                 ignoreSafeArea: Bool,
                                 layoutProvider: (any CXPopoverLayoutProvider)?) -> CGRect {
        let insets = ignoreSafeArea ? .zero : safeAreaInsets
        let contentSize = layoutProvider?.popover(sizeForPopover: containerSize, safeAreaInsets: safeAreaInsets) ?? .zero
        let origin = CXPopoverHelper.makeOrigin(
            containerSize: containerSize,
            contentSize: contentSize,
            safeAreaInsets: insets,
            anchor: anchor)
        
        return CGRect(origin: origin, size: contentSize)
    }
    
    static func makeOrigin(containerSize: CGSize, contentSize: CGSize, safeAreaInsets: UIEdgeInsets, anchor: CXPopoverBehavior.Anchor) -> CGPoint {
        let width = containerSize.width
        let height = containerSize.height
        
        let contentWidth = contentSize.width
        let contentHeight = contentSize.height
        
        switch anchor {
        case .top:
            return CGPoint(x: (width - contentWidth) / 2, y: safeAreaInsets.top)
        case .bottom:
            return CGPoint(x: (width - contentWidth) / 2, y: height - safeAreaInsets.bottom - contentHeight)
        case .leading:
            return CGPoint(x: safeAreaInsets.left, y: (height - contentHeight) / 2)
        case .trailing:
            return CGPoint(x: width - safeAreaInsets.right - contentWidth, y: (height - contentHeight) / 2)
        case .topLeading:
            return CGPoint(x: safeAreaInsets.left, y: safeAreaInsets.top)
        case .topTrailing:
            return CGPoint(x: width - safeAreaInsets.right - contentWidth, y: safeAreaInsets.top)
        case .bottomLeading:
            return CGPoint(x: safeAreaInsets.left, y: height - safeAreaInsets.bottom - contentHeight)
        case .bottomTrailing:
            return CGPoint(x: width - safeAreaInsets.right - contentWidth, y: height - safeAreaInsets.bottom - contentHeight)
        case .center:
            return CGPoint(x: (width - contentWidth) / 2, y: (height - contentHeight) / 2)
        }
    }
    
    static func stylizePopover(_ view: UIView, behavior: CXPopoverBehavior) {
        view.layer.masksToBounds = true
        if behavior.cornerRadius > .zero {
            view.layer.cornerRadius = behavior.cornerRadius
            view.layer.maskedCorners = behavior.enableSmartCorner ? makeSmartMaskedCorners(anchor: behavior.anchor) : behavior.maskedCorners
        }
    }
    
    private static func makeSmartMaskedCorners(anchor: CXPopoverBehavior.Anchor) -> CACornerMask {
        switch anchor {
        case .top:
            return [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case .bottom:
            return [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        case .leading:
            return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .trailing:
            return [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .topLeading:
            return [.layerMaxXMaxYCorner]
        case .topTrailing:
            return [.layerMinXMaxYCorner]
        case .bottomLeading:
            return [.layerMaxXMinYCorner]
        case .bottomTrailing:
            return [.layerMinXMinYCorner]
        case .center:
            return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
}
