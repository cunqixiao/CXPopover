//
//  CXPopoverAnimationResolver.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

final class CXPopoverAnimationResolver {
    
    // MARK: - Internal methods
    
    static func resolveAnimator(metadata: CXAnimationMetadata, isPresenting: Bool) -> any UIViewControllerAnimatedTransitioning {
        switch metadata.effect {
        case .custom(let animation):
            animation.isPresenting = isPresenting
            return animation
        case .fade, .slide, .zoom, .complex(_):
            let animation = resolveAnimation(metadata: metadata, isPresenting: isPresenting)
            return sealWithAnimator(animation, metadata: metadata)
        }
    }
    
    // MARK: - Private methods
    
    private static func resolveAnimation(metadata: CXAnimationMetadata, isPresenting: Bool) -> any CXPopoverAnimationCoordinator {
        switch metadata.effect {
        case .fade:
            return resolveFadeAnimation(metadata: metadata, isPresenting: isPresenting)
        case .zoom:
            return resolveZoomAnimation(metadata: metadata, isPresenting: isPresenting)
        case .slide:
            return resolveSlideAnimation(metadata: metadata, isPresenting: isPresenting)
        case .complex(let animations):
            return resolveComplexAnimation(animations, metadata: metadata, isPresenting: isPresenting)
        case .custom(_):
            assertionFailure("Invalid popover animation coordinator")
            return resolveFadeAnimation(metadata: metadata, isPresenting: isPresenting)
        }
    }
    
    private static func resolveFadeAnimation(metadata: CXAnimationMetadata, isPresenting: Bool) -> any CXPopoverAnimationCoordinator {
        CXFadeAnimation(duration: metadata.duration, options: metadata.options, isPresenting: isPresenting)
    }
    
    private static func resolveZoomAnimation(metadata: CXAnimationMetadata, isPresenting: Bool) -> any CXPopoverAnimationCoordinator {
        CXZoomAnimation(duration: metadata.duration, options: metadata.options, isPresenting: isPresenting)
    }
    
    private static func resolveSlideAnimation(metadata: CXAnimationMetadata, isPresenting: Bool) -> any CXPopoverAnimationCoordinator {
        CXSlideAnimation(
            edge: isPresenting ? metadata.moveIn : metadata.moveOut,
            duration: metadata.duration,
            options: metadata.options,
            isPresenting: isPresenting)
    }
    
    private static func resolveComplexAnimation(_ animations: [CXAnimationMetadata],
                                                metadata: CXAnimationMetadata,
                                                isPresenting: Bool) -> any CXPopoverAnimationCoordinator {
        let popoverAnimations = animations.map { Self.resolveAnimation(metadata: $0, isPresenting: isPresenting) }
        return CXComplexPopoverAnimation(animations: popoverAnimations, duration: metadata.duration, options: metadata.options, isPresenting: isPresenting)
    }
    
    private static func sealWithAnimator(_ animation: any CXPopoverAnimationCoordinator,
                                         metadata: CXAnimationMetadata) -> any UIViewControllerAnimatedTransitioning {
        metadata.bounces ? CXBounceAnimator(
            animation: animation,
            damping: metadata.damping,
            velocity: metadata.velocity) : CXBasicAnimator(animation: animation)
    }
}
