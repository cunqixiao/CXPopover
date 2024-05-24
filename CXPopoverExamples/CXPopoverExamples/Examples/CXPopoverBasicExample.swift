//
//  CXPopoverBasicExample.swift
//  CXPopoverExamples
//
//  Created by Cunqi Xiao on 5/23/24.
//

import UIKit
import CXPopover

class CXPopoverBasicExample: CXPopoverExample {
    
    override func didTapMenuButton() {
        let popover = CXPopoverController()
        present(popover, animated: true)
    }
    
}
