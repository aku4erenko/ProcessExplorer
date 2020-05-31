//
//  SplitViewController.swift
//  ProcessExplorer
//
//  Created by Aleksandr Kucherenko on 31.05.2020.
//  Copyright © 2020 Aleksandr Kucherenko. All rights reserved.
//

import Cocoa

class ProcessSplitViewController: NSSplitViewController {
	//MARK: Properties
	weak var delegate: ProcessSplitViewControllerDelegate?
	private weak var detailsViewController: ProcessDetailsViewController?
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
	
		// Setup delagetes chain
		for itemViewController in splitViewItems.map({ $0.viewController }) {
			switch itemViewController {
			case let controller as ProcessesViewController:
				controller.delegate = self
				// Update count of active processes
				delegate?.proccessSplitViewController(self, didUpdatedCountOfProcesses: controller.processes.count)
			case let controller as ProcessDetailsViewController:
				detailsViewController = controller
				
			default:
				break
			}
		}
	}
}

//MARK: -
extension ProcessSplitViewController: ProcessesViewControllerDelegate {
	func processesViewController(_ controller: ProcessesViewController, didUpdateCountOfProcesses count: Int) {
		delegate?.proccessSplitViewController(self, didUpdatedCountOfProcesses: count)
	}
	
	func processesViewController(_ controller: ProcessesViewController, didSelecteProcess process: Process?) {
		detailsViewController?.process = process
	}
}

//MARK: -
protocol ProcessSplitViewControllerDelegate: AnyObject {
	func proccessSplitViewController(_ controller: ProcessSplitViewController, didUpdatedCountOfProcesses count: Int)
}
