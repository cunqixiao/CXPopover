//
//  CXPresentationBehavior.swift
//  CXPopover
//
//  Created by Cunqi Xiao on 5/21/24.
//

import UIKit

public struct CXPresentationBehavior {
    
    /// Controls whether the safe area should be ignored when
    /// calculating the origin of the presented view.
    public var ignoreSafeArea: Bool
    
    /// The anchor point of the presented view. for simple value, it will be centered,
    /// for example (`.leading` refers to the center left of the screen).
    public var anchor: CXPresentationBehavior.Anchor
    
    /// Controls whether the smart corner should be enabled. when enabled,
    /// The `cornerRadius` will be applied to the presented view based on the `anchor`.
    public var enableSmartCorner: Bool
    
    /// The corner radius of the presented view.
    public var cornerRadius: CGFloat
    
    /// The masked corners of the presented view.
    public var maskedCorners: CACornerMask
    
    /// The background color of the `backgroundMask` view.
    public var backgroundColor: UIColor

    /// Controls whether the presentation is modal.
    /// if `true`, tap `backgroundMask` to dismiss is disabled.
    public var isModal: Bool
    
    /// Defines the animation metadata (duration, option, bounces etc.) for the presentation.
    public var animationMetadata: CXAnimationMetadata
    
    /// Controls whether the interactive animation is enabled.
    public var interactiveAnimationMode: InteractiveAnimationMode
}

// MARK: - Predefined behaviors

public extension CXPresentationBehavior {
    static let `default` = CXPresentationBehavior(
        ignoreSafeArea: true,
        anchor: .center,
        enableSmartCorner: true,
        cornerRadius: 16.0,
        maskedCorners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner],
        backgroundColor: .black.withAlphaComponent(0.5),
        isModal: false,
        animationMetadata: .fade(),
        interactiveAnimationMode: .none)
}

// MARK: - Anchor

public extension CXPresentationBehavior {
    enum Anchor: CaseIterable {
        case top
        case bottom
        case leading
        case trailing
        case topLeading
        case topTrailing
        case bottomLeading
        case bottomTrailing
        case center
    }
}

// MARK: - Interactive Animation

public extension CXPresentationBehavior {
    enum InteractiveAnimationMode {
        case none, dismissal, both
    }
}
