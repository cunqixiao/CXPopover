//
//  CXAnchorPopoverController+AnchorContainerView.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/24/24.
//

import UIKit

extension CXAnchorPopoverController {
    final class AnchorContainerView: UIView, CXPopoverContentViewRepresentable {
        
        // MARK: - Internal properties
        
        let behavior: CXPopoverBehavior
        
        // MARK: - Private properties
        
        private let arrowView = ArrowView(frame: CGRect(origin: .zero, size: ArrowView.size))
        private let contentView: any CXPopoverContentViewRepresentable
        
        private var arrowEdge: UIRectEdge = .all
        private var containerSize: CGSize = .zero
        private var contentSize: CGSize = .zero
        
        // MARK: - Initializers
        
        init(contentView: any CXPopoverContentViewRepresentable,
             anchor: CXPopoverBehavior.Anchor,
             behavior: CXPopoverBehavior) {
            self.contentView = contentView
            self.behavior = Self.overridePopoverBehavior(behavior: behavior, anchor: anchor)
            super.init(frame: .zero)
            setupViews()
            CXPopoverHelper.stylizePopover(contentView, behavior: behavior)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            // https://stackoverflow.com/a/11924449/24016318
            // This didn't break the private API rule, because for `It's a property that you can get to in other ways.`
            // the hierarchy is fixed, you can always cast superview to find the popover controller.
            guard let containerFrame = parent(of: CXPopoverController.self)?.view.frame,
                  case .anchor (let anchorFrame, _, _) = behavior.anchor else {
                assertionFailure("The popover controller is missing. or anchor is invalid.")
                tearDownViews()
                return
            }
            
            let minX = max(anchorFrame.minX, containerFrame.minX)
            let maxX = min(anchorFrame.maxX, containerFrame.maxX)
            let minY = max(anchorFrame.minY, containerFrame.minY)
            let maxY = min(anchorFrame.maxY, containerFrame.maxY)
            
            let offsetX = ArrowView.size.width / 2 + containerFrame.minX
            let offsetY = ArrowView.size.height / 2 + containerFrame.minY
            
            let arrowX: CGFloat
            if anchorFrame.width >= containerFrame.width {
                arrowX = anchorFrame.midX - offsetX
            } else {
                arrowX = (maxX - minX) / 2 + anchorFrame.minX - offsetX
            }
            
            let arrowY: CGFloat
            if anchorFrame.height >= containerFrame.height {
                arrowY = anchorFrame.midY - offsetY
            } else {
                arrowY = (maxY - minY) / 2 + anchorFrame.minY - offsetY
            }
            
            arrowView.attachArrowOn(edge: arrowEdge)
            
            switch arrowEdge {
            case .top:
                contentView.frame = CGRect(origin: frame.origin, size: contentSize)
                arrowView.frame = CGRect(origin: CGPoint(x: arrowX, y: contentSize.height), size: ArrowView.size)
            case .bottom:
                contentView.frame = CGRect(origin: CGPoint(x: 0, y: ArrowView.size.height), size: contentSize)
                arrowView.frame = CGRect(origin: CGPoint(x: arrowX, y: 0), size: ArrowView.size)
            case .left:
                contentView.frame = CGRect(origin: frame.origin, size: contentSize)
                arrowView.frame = CGRect(origin: CGPoint(x: contentSize.width, y: arrowY), size: ArrowView.size)
            case .right:
                contentView.frame = CGRect(origin: CGPoint(x: ArrowView.size.width, y: 0), size: contentSize)
                arrowView.frame = CGRect(origin: CGPoint(x: 0, y: arrowY), size: ArrowView.size)
            default:
                tearDownViews()
            }
        }
        
        // MARK: - CXPopoverContentViewRepresentable
        
        func popover(sizeForPopover containerSize: CGSize, safeAreaInsets: UIEdgeInsets) -> CGSize {
            let preferredEdge = Self.extractPreferredEdge(from: behavior.anchor)
            let contentSize = contentView.popover(sizeForPopover: containerSize, safeAreaInsets: safeAreaInsets)
            let hContentSize = Self.updateContentSize(contentSize, arrowSize: arrowView.frame.size, with: .left)
            let vContentSize = Self.updateContentSize(contentSize, arrowSize: arrowView.frame.size, with: .top)
            
            let horizontalEdge = CXPopoverHelper.makeAnchorEdge(anchor: behavior.anchor, containerSize: containerSize, contentSize: hContentSize, safeAreaInsets: safeAreaInsets)   // expect .left or .right
            let verticalEdge = CXPopoverHelper.makeAnchorEdge(anchor: behavior.anchor, containerSize: containerSize, contentSize: vContentSize, safeAreaInsets: safeAreaInsets) // expect .top or .bottom
            
            if verticalEdge == preferredEdge {
                arrowEdge = verticalEdge
            } else if horizontalEdge == preferredEdge {
                arrowEdge = horizontalEdge
            } else if horizontalEdge.isHorizontal && verticalEdge.isHorizontal {
                arrowEdge = horizontalEdge
            } else if horizontalEdge.isVertical && verticalEdge.isVertical {
                arrowEdge = verticalEdge
            } else {
                assertionFailure("Impossible to reach here.")
                arrowEdge = .all
            }
            
            self.containerSize = containerSize
            self.contentSize = contentSize
            return arrowEdge == .top || arrowEdge == .bottom ? vContentSize : hContentSize
        }
        
        // MARK: - Private methods
        
        private func setupViews() {
            [arrowView, contentView].forEach {
                addSubview($0)
            }
        }
        
        private func tearDownViews() {
            [arrowView, contentView].forEach {
                $0.removeFromSuperview()
            }
        }
        
        private static func overridePopoverBehavior(behavior: CXPopoverBehavior, anchor: CXPopoverBehavior.Anchor) -> CXPopoverBehavior {
            var overridedBehavior = CXPopoverBehavior.default
            overridedBehavior.cornerRadius = .zero
            overridedBehavior.animationMetadata = .fade()
            overridedBehavior.animationMetadata.bounces = behavior.animationMetadata.bounces
            overridedBehavior.anchor = anchor
            overridedBehavior.backgroundColor = .clear
            overridedBehavior.ignoreSafeArea = false
            
            return overridedBehavior
        }
        
        private static func updateContentSize(_ contentSize: CGSize, arrowSize: CGSize, with edge: UIRectEdge) -> CGSize {
            switch edge {
            case .top, .bottom:
                return CGSize(width: contentSize.width, height: contentSize.height + arrowSize.height)
            case .left, .right:
                return CGSize(width: contentSize.width + arrowSize.width, height: contentSize.height)
            default:
                return contentSize
            }
        }
        
        private static func extractPreferredEdge(from anchor: CXPopoverBehavior.Anchor) -> UIRectEdge {
            switch anchor {
            case .anchor(_, _, let preferEdge):
                return preferEdge
            default:
                return .all
            }
        }
        
        private static func extractAnchorFrame(from anchor: CXPopoverBehavior.Anchor) -> CGRect {
            switch anchor {
            case .anchor(let frame, _, _):
                return frame
            default:
                return .zero
            }
        }
    }
}

extension UIRectEdge {
    var isHorizontal: Bool {
        self == .left || self == .right
    }
    
    var isVertical: Bool {
        self == .top || self == .bottom
    }
}
