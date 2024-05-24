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
        case .anchor(_, _, _):
            return makeAnchorPoint(anchor: anchor, containerSize: containerSize, contentSize: contentSize, safeAreaInsets: safeAreaInsets)
        }
    }
    
    static func makeAnchorEdge(anchor: CXPopoverBehavior.Anchor, containerSize: CGSize, contentSize: CGSize, safeAreaInsets: UIEdgeInsets) -> UIRectEdge {
        guard case .anchor(let anchorFrame, let anchorInsets, let preferredEdge) = anchor else {
            assertionFailure("Not a valid anchor enum case.")
            return .all
        }
        var validEdges: [UIRectEdge] = []
        let insets = UIEdgeInsets(top: safeAreaInsets.top + anchorInsets.top,
                                 left: safeAreaInsets.left + anchorInsets.left,
                                 bottom: safeAreaInsets.bottom + anchorInsets.bottom,
                                 right: safeAreaInsets.right + anchorInsets.right)
        
        if anchorFrame.minY - contentSize.height - insets.top >= 0 {
            validEdges.append(.top)
        }
        
        if anchorFrame.maxY + contentSize.height + insets.bottom <= containerSize.height {
            validEdges.append(.bottom)
        }
        
        if anchorFrame.minX - contentSize.width - insets.left >= 0 {
            validEdges.append(.left)
        }
        
        if anchorFrame.maxX + contentSize.width + insets.right <= containerSize.width {
            validEdges.append(.right)
        }
        
        if anchorFrame.maxX < insets.left + 20 || anchorFrame.maxX + insets.right > containerSize.width - 20 {
            validEdges.removeAll(where: { $0 == .top || $0 == .bottom })
        }
        
        if anchorFrame.maxY < insets.top + 20 || anchorFrame.maxY + insets.bottom > containerSize.height - 20 {
            validEdges.removeAll(where: { $0 == .left || $0 == .right })
        }
        
        return validEdges.contains(preferredEdge) ? preferredEdge : (validEdges.first ?? .all)
    }
    
    static func stylizePopover(_ view: UIView, behavior: CXPopoverBehavior) {
        if behavior.cornerRadius > .zero {
            view.layer.masksToBounds = true
            view.layer.cornerRadius = behavior.cornerRadius
            view.layer.maskedCorners = behavior.enableSmartCorner ? makeSmartMaskedCorners(anchor: behavior.anchor) : behavior.maskedCorners
        }
    }
    
    // MARK: - Private methods
    
    private static func makeAnchorPoint(anchor: CXPopoverBehavior.Anchor, 
                                        containerSize: CGSize,
                                        contentSize: CGSize,
                                        safeAreaInsets: UIEdgeInsets) -> CGPoint {
        guard case .anchor(let anchorFrame, let anchorInsets, _) = anchor else {
            assertionFailure("Not a valid anchor enum case.")
            return .zero
        }
        
        let finalEdge = makeAnchorEdge(anchor: anchor, containerSize: containerSize, contentSize: contentSize, safeAreaInsets: safeAreaInsets)
        let insets = UIEdgeInsets(top: safeAreaInsets.top + anchorInsets.top,
                                 left: safeAreaInsets.left + anchorInsets.left,
                                 bottom: safeAreaInsets.bottom + anchorInsets.bottom,
                                 right: safeAreaInsets.right + anchorInsets.right)
        
        switch finalEdge {
        case .top, .bottom:
            var x: CGFloat = 0
            if anchorFrame.midX - contentSize.width / 2 < insets.left {
                x = insets.left
            } else if anchorFrame.midX + contentSize.width / 2 > containerSize.width - insets.right {
                x = containerSize.width - insets.right - contentSize.width
            } else {
                x = anchorFrame.midX - contentSize.width / 2
            }
            let y = finalEdge == .bottom ? (anchorFrame.maxY + anchorInsets.bottom) : anchorFrame.minY - contentSize.height - anchorInsets.top
            return CGPoint(x: x, y: y)
        case .left, .right:
            var y: CGFloat = 0
            
            if anchorFrame.midY - contentSize.height / 2 < insets.top {
                y = insets.top
            } else if anchorFrame.midY + contentSize.height / 2 > containerSize.height - insets.bottom {
                y = containerSize.height - insets.bottom - contentSize.height
            } else {
                y = anchorFrame.midY - contentSize.height / 2
            }
            
            let x = finalEdge == .left ? (anchorFrame.minX - contentSize.width - anchorInsets.left) : (anchorFrame.maxX + anchorInsets.right)
            return CGPoint(x: x, y: y)
        default:
            return .zero
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
        case .center, .anchor(_, _, _):
            return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
}
