//
//  CXAnchorPopoverController+AnchorContainerView+ArrowView.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/24/24.
//

import UIKit

extension CXAnchorPopoverController.AnchorContainerView {
    
    /// [Create rounded corner triangle](https://stackoverflow.com/a/46390337/24016318)
    final class ArrowView: UIView {
        
        // MARK: - Constants
        
        static let size = CGSize(width: 16, height: 16)
        
        // MARK: - Initializers
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            makeRoundedTriangle()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Internal methods
        
        func attachArrowOn(edge: UIRectEdge) {
            transform = makeTransformRotation(on: edge)
        }
        
        // MARK: - Private methods
        
        private func makeRoundedTriangle() {
            let triangle = CAShapeLayer()
            triangle.fillColor = UIColor.systemBackground.cgColor
            triangle.path = createRoundedTriangle(width: Self.size.width, height: Self.size.height, radius: 1)
            triangle.position = CGPoint(x: Self.size.width / 2, y: Self.size.height / 2)
            layer.addSublayer(triangle)
        }
        
        private func createRoundedTriangle(width: CGFloat, height: CGFloat, radius: CGFloat) -> CGPath {
            // Draw the triangle path with its origin at the center.
            let point1 = CGPoint(x: -width / 2, y: height / 2)
            let point2 = CGPoint(x: 0, y: -height / 2)
            let point3 = CGPoint(x: width / 2, y: height / 2)
            
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: height / 2))
            path.addArc(tangent1End: point1, tangent2End: point2, radius: 0)    // Left
            path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)    // Top
            path.addArc(tangent1End: point3, tangent2End: point1, radius: 0)   // Right
            path.closeSubpath()
            
            return path
        }
        
        private func makeTransformRotation(on edge: UIRectEdge) -> CGAffineTransform {
            switch edge {
            case .right:
                return transform.rotated(by: -45 * .pi / 180)
            case .top:
                return transform.rotated(by: 180 * .pi / 180)
            case .left:
                return transform.rotated(by: 45 * .pi / 180)
            default:
                return .identity
            }
        }
    }
}
