//
//  File.swift
//  
//
//  Created by Cunqi Xiao on 5/23/24.
//

import UIKit

public protocol CXPopoverCustomAnimator: UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool { get set }
    
}
