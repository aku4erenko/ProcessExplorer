//
//  ProcessesViewController.swift
//  ProcessExplorer
//
//  Created by Aleksandr Kucherenko on 31.05.2020.
//  Copyright © 2020 Aleksandr Kucherenko. All rights reserved.
//

import Cocoa

class ProcessesViewController: NSViewController {
	
	@objc var processes = [Process]()
	
	private let monitor = ProcessMonitor()
	
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
		}
	}
}
