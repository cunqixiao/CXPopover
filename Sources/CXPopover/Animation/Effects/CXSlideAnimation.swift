//
//  CXSlideAnimation.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

class CXSlideAnimation: CXTransformAnimation {
    
    // MARK: - Public properties
    
    public let edge: CXAnimationMetadata.Edge
    
    // MARK: - Initializer
    
    public init(edge: CXAnimationMetadata.Edge,
                duration: TimeInterval,
                options: UIView.AnimationOptions,
                isPresenting: Bool) {
        self.edge = edge
        super.init(duration: duration, options: options, isPresenting: isPresenting)
    }
    
    override func setupTransform(frame: CGRect) -> CGAffineTransform {
        if isPresenting {
            return decodeTransform(edge: edge, frame: frame)
        }
        return .identity
    }
    
    override func updateTransform(frame: CGRect) -> CGAffineTransform {
        if isPresenting {
            return .identity
        }
        return decodeTransform(edge: edge, frame: frame)
    }
    
    // MARK: - Private methods
    
    private func decodeTransform(edge: CXAnimationMetadata.Edge, frame: CGRect) -> CGAffineTransform {
        switch edge {
        case .top:
            return CGAffineTransform(translationX: 0, y: -frame.maxY)
        case .bottom:
            return CGAffineTransform(translationX: 0, y: frame.maxY)
        case .left:
            return CGAffineTransform(translationX: -frame.maxX, y: 0)
        case .right:
            return CGAffineTransform(translationX: frame.maxX, y: 0)
        case .center:
            return .identity
        }
    }
}
