//
//  CXPopoverExampleListViewController.swift
//  CXPopoverExamples
//
//  Created by Cunqi Xiao on 5/23/24.
//

import UIKit

class CXPopoverExampleListViewController: UITableViewController {
    
    // MARK: - Examples
    
    enum Example: Int, CaseIterable {
        case basic
        case interactive
        case playground
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stylize()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Example.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let example = Example.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = example.title
        cell.tag = example.rawValue
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let example = Example(rawValue: indexPath.row) else { return }
        let viewController = Router.route(example: example)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Private methods
    
    private func stylize() {
        title = "CXPopover Examples"
        view.backgroundColor = .systemBackground
    }
    
}

// MARK: - Router

extension CXPopoverExampleListViewController {
    class Router {
        static func route(example: Example) -> UIViewController {
            switch example {
            case .basic:
                return CXPopoverBasicExample(title: example.title)
            case .playground:
                return CXPopoverBasicExample(title: example.title)
            case .interactive:
                return CXPopoverInteractiveExample(title: example.title)
            }
        }
    }
}

// MARK: - Example extensions

extension CXPopoverExampleListViewController.Example {
    var title: String {
        switch self {
        case .basic:
            return "Basic popover"
        case .playground:
            return "Popover playground"
        case .interactive:
            return "Interactive popover"
        }
    }
}
