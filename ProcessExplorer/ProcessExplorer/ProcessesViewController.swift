//
//  ProcessesViewController.swift
//  ProcessExplorer
//
//  Created by Aleksandr Kucherenko on 31.05.2020.
//  Copyright © 2020 Aleksandr Kucherenko. All rights reserved.
//

import Cocoa

class ProcessesViewController: NSViewController {
	
	//MARK: Properties
	@objc var processes = [Process]()
	@objc var selectionIndexes = IndexSet() {
		didSet {
			delegate?.processesViewController(self, didSelecteProcess: arrayController?.selectedObjects.first as? Process)
		}
	}
	
	weak var delegate: ProcessesViewControllerDelegate?
	@IBOutlet weak var arrayController: NSArrayController?
	
	private let monitor = ProcessMonitor()
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		monitor.start { [weak self] event in
			guard let self = self else { return }
			
			self.willChangeValue(for: \.processes)
			
			switch event {
			case .launch(let launchedProcesses):
				self.processes.append(contentsOf: launchedProcesses)
			case .terminate(let terminatedPIDs):
				self.processes.removeAll { terminatedPIDs.contains($0.pid) }
			}
			
			self.didChangeValue(for: \.processes)
			
			self.delegate?.processesViewController(self, didUpdateCountOfProcesses: self.processes.count)
		}
	}
}

//MARK: -
protocol ProcessesViewControllerDelegate: AnyObject {
	func processesViewController(_ controller: ProcessesViewController, didUpdateCountOfProcesses count: Int)
	func processesViewController(_ controller: ProcessesViewController, didSelecteProcess process: Process?)
}
