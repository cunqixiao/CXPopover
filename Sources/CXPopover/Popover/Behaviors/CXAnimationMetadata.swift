//
//  CXAnimationMetadata.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

// MARK: - Animation

public struct CXAnimationMetadata {
    
    // MARK: - Constants
    
    public static let defaultDuration = 0.25
    
    // MARK: - Public Properties
    
    /// Controls whether the interactive dismiss is enabled.
    public var isInteractiveAnimationDisabled: Bool
    
    public var duration: TimeInterval
    
    public var options: UIView.AnimationOptions
    
    /// If `bounces` is `false`, `damping` and `velocity` will be ignored.
    public var bounces: Bool
    
    public var damping: CGFloat
    
    public var velocity: CGFloat
    
    // MARK: - // Internal properties
    
    var effect: AnimationEffect
    
    var moveIn: CXAnimationMetadata.Edge
    
    var moveOut: CXAnimationMetadata.Edge
}

// MARK: - Edge

public extension CXAnimationMetadata {
    enum Edge {
        case top, bottom, left, right, center
    }
}

// MARK: - Effects

extension CXAnimationMetadata {
    enum AnimationEffect {
        case fade
        case zoom
        case slide
        case complex(animations: [CXAnimationMetadata])
        case custom(animation: any CXPopoverCustomAnimator)
    }
}

// MARK: - Convenient maker

public extension CXAnimationMetadata {
    static func fade(duration: TimeInterval = Self.defaultDuration, options: UIView.AnimationOptions = .curveEaseInOut) -> CXAnimationMetadata {
        var metadata = CXAnimationMetadata.default
        metadata.effect = .fade
        metadata.duration = duration
        metadata.options = options
        return metadata
    }
    
    static func slide(duration: TimeInterval = Self.defaultDuration,
                      options: UIView.AnimationOptions = .curveEaseInOut,
                      moveIn: Edge,
                      moveOut: Edge) -> CXAnimationMetadata {
        var metadata = CXAnimationMetadata.default
        metadata.effect = .slide
        metadata.duration = duration
        metadata.options = options
        metadata.moveIn = moveIn
        metadata.moveOut = moveOut
        return metadata
    }
    
    static func zoom(duration: TimeInterval = Self.defaultDuration, options: UIView.AnimationOptions = .curveEaseInOut) -> CXAnimationMetadata {
        var metadata = CXAnimationMetadata.default
        metadata.effect = .zoom
        metadata.duration = duration
        metadata.options = options
        return metadata
    }
    
    static func custom(animation: any CXPopoverCustomAnimator) -> CXAnimationMetadata {
        var metadata = CXAnimationMetadata.default
        metadata.effect = .custom(animation: animation)
        return metadata
    }
    
    /// `animations` orders matters, `zoom` will update the transform to `identity`,
    /// Make sure the `transform` has been setup correctly.
    static func complex(animations: [CXAnimationMetadata],
                        duration: TimeInterval = Self.defaultDuration,
                        options: UIView.AnimationOptions = .curveEaseInOut) -> CXAnimationMetadata {
        var metadata = CXAnimationMetadata.default
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
    
    private static let `default` = CXAnimationMetadata(
        isInteractiveAnimationDisabled: true,
        duration: Self.defaultDuration,
        options: [.curveEaseInOut],
        bounces: false,
        damping: 0.8,
        velocity: 0.6,
        effect: .fade,
        moveIn: .bottom,
        moveOut: .bottom)
}
