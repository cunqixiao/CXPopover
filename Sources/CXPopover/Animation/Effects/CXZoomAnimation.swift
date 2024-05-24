//
//  File.swift
//  
//
//  Created by Cunqi Xiao on 5/22/24.
//

import UIKit

class CXZoomAnimation: CXTransformAnimation {
    override func setupTransform(frame: CGRect) -> CGAffineTransform {
        if isPresenting {
            return CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        return .identity
    }
    
    override func updateTransform(frame: CGRect) -> CGAffineTransform {
        if isPresenting {
            return .identity
        }
        return CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
}
