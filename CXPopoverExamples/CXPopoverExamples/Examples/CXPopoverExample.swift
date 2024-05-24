//
//  CXPopoverExample.swift
//  CXPopoverExamples
//
//  Created by Cunqi Xiao on 5/23/24.
//

import UIKit

class CXPopoverExample: UIViewController {
    
    lazy var buttonXPosition: NSLayoutConstraint = {
        menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0)
    }()
    
    lazy var buttonYPosition: NSLayoutConstraint = {
        menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
    }()
    
    // MARK: - Private properties
    
    private lazy var menuButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Popover"
        configuration.buttonSize = .medium
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(didTapMenuButton(sender:)), for: .touchUpInside)
        return button
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
    
    @objc func didTapMenuButton(sender: UIButton) {
        
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndLayoutConstraints() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(menuButton)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonXPosition,
            buttonYPosition,
            menuButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func stylize() {
        view.backgroundColor = .systemBackground
    }
}
