//
//  CXPopoverHelper.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

class CXPopoverHelper {
    
    // MARK: - Static internal methods
    
    static func makeOrigin(containerSize: CGSize, contentSize: CGSize, insets: UIEdgeInsets, anchor: CXPopoverBehavior.Anchor) -> CGPoint {
        let width = containerSize.width
        let height = containerSize.height
        
        let contentWidth = contentSize.width
        let contentHeight = contentSize.height
        
        switch anchor {
        case .top:
            return CGPoint(x: (width - contentWidth) / 2, y: insets.top)
        case .bottom:
            return CGPoint(x: (width - contentWidth) / 2, y: height - insets.bottom - contentHeight)
        case .leading:
            return CGPoint(x: insets.left, y: (height - contentHeight) / 2)
        case .trailing:
            return CGPoint(x: width - insets.right - contentWidth, y: (height - contentHeight) / 2)
        case .topLeading:
            return CGPoint(x: insets.left, y: insets.top)
        case .topTrailing:
            return CGPoint(x: width - insets.right - contentWidth, y: insets.top)
        case .bottomLeading:
            return CGPoint(x: insets.left, y: height - insets.bottom - contentHeight)
        case .bottomTrailing:
            return CGPoint(x: width - insets.right - contentWidth, y: height - insets.bottom - contentHeight)
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
