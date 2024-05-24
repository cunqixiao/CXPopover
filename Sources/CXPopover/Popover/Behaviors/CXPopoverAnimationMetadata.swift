//
//  CXAnimationMetadata.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

// MARK: - Animation

public struct CXPopoverAnimationMetadata {
    
    // MARK: - Constants
    
    public static let defaultDuration = 0.25
    
    // MARK: - Public Properties
    
    public var duration: TimeInterval
    
    public var options: UIView.AnimationOptions
    
    /// If `bounces` is `false`, `damping` and `velocity` will be ignored.
    public var bounces: Bool
    
    public var damping: CGFloat
    
    public var velocity: CGFloat
    
    // MARK: - // Internal properties
    
    var effect: AnimationEffect
    
    var moveIn: CXPopoverAnimationMetadata.Edge
    
    var moveOut: CXPopoverAnimationMetadata.Edge
}

// MARK: - Edge

public extension CXPopoverAnimationMetadata {
    enum Edge {
        case top, bottom, left, right, center
    }
}

// MARK: - Effects

extension CXPopoverAnimationMetadata {
    enum AnimationEffect {
        case fade
        case zoom
        case slide
        case complex(animations: [CXPopoverAnimationMetadata])
        case custom(animation: any CXPopoverCustomAnimator)
    }
}

// MARK: - Convenient maker

public extension CXPopoverAnimationMetadata {
    static func fade(duration: TimeInterval = Self.defaultDuration, options: UIView.AnimationOptions = .curveEaseInOut) -> CXPopoverAnimationMetadata {
        var metadata = CXPopoverAnimationMetadata.default
        metadata.effect = .fade
        metadata.duration = duration
        metadata.options = options
        return metadata
    }
    
    static func slide(duration: TimeInterval = Self.defaultDuration,
                      options: UIView.AnimationOptions = .curveEaseInOut,
                      moveIn: Edge,
                      moveOut: Edge) -> CXPopoverAnimationMetadata {
        var metadata = CXPopoverAnimationMetadata.default
        metadata.effect = .slide
        metadata.duration = duration
        metadata.options = options
        metadata.moveIn = moveIn
        metadata.moveOut = moveOut
        return metadata
    }
    
    static func zoom(duration: TimeInterval = Self.defaultDuration, options: UIView.AnimationOptions = .curveEaseInOut) -> CXPopoverAnimationMetadata {
        var metadata = CXPopoverAnimationMetadata.default
        metadata.effect = .zoom
        metadata.duration = duration
        metadata.options = options
        return metadata
    }
    
    static func custom(animation: any CXPopoverCustomAnimator) -> CXPopoverAnimationMetadata {
        var metadata = CXPopoverAnimationMetadata.default
        metadata.effect = .custom(animation: animation)
        return metadata
    }
    
    /// `animations` orders matters, `zoom` will update the transform to `identity`,
    /// Make sure the `transform` has been setup correctly.
    static func complex(animations: [CXPopoverAnimationMetadata],
                        duration: TimeInterval = Self.defaultDuration,
                        options: UIView.AnimationOptions = .curveEaseInOut) -> CXPopoverAnimationMetadata {
        var metadata = CXPopoverAnimationMetadata.default
        let filteredAnimations = animations.filter { animation in
            switch animation.effect {
            case .fade, .zoom, .slide:
                return true
            case .complex(_), .custom(_):
                return false
            }
        }
        metadata.effect = .complex(animations: filteredAnimations)
        metadata.duration = duration
        metadata.options = options
        return metadata
    }
    
    private static let `default` = CXPopoverAnimationMetadata(
        duration: Self.defaultDuration,
        options: [.curveEaseInOut],
        bounces: false,
        damping: 0.8,
        velocity: 0.6,
        effect: .fade,
        moveIn: .bottom,
        moveOut: .bottom)
}
