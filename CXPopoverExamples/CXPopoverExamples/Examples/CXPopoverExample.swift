//
//  CXPopoverExample.swift
//  CXPopoverExamples
//
//  Created by Cunqi Xiao on 5/23/24.
//

import UIKit

class CXPopoverExample: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var menuButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Popover"
        configuration.buttonSize = .medium
        
        return UIButton(configuration: configuration, primaryAction: UIAction(handler: { [unowned self] _ in
            didTapMenuButton()
        }))
    }()
    
    // MARK: - Initializers
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsAndLayoutConstraints()
        stylize()
    }
    
    // MARK: - Internal methods
    
    func didTapMenuButton() {
        
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndLayoutConstraints() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(menuButton)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func stylize() {
        view.backgroundColor = .systemBackground
    }
}
