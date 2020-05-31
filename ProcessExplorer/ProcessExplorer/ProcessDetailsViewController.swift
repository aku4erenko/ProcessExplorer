//
//  ProcessDetailsViewController.swift
//  ProcessExplorer
//
//  Created by Aleksandr Kucherenko on 31.05.2020.
//  Copyright © 2020 Aleksandr Kucherenko. All rights reserved.
//

import Cocoa

class ProcessDetailsViewController: NSViewController {
	
	//MARK: Outlets
	@IBOutlet weak var pidLabel: NSTextField!
	@IBOutlet weak var uidLabel: NSTextField!
	@IBOutlet weak var pathLabel: NSTextField!
	
	//MARK: Properties
	var process: Process? {
		didSet {
			setupContent()
		}
	}
	
	//MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupContent()
	}
	
	private func setupContent() {
		self.pidLabel.cell?.stringValue = process.map{ "\($0.pid)" } ?? ""
		self.uidLabel.cell?.stringValue = process.map{ "\($0.uid)" } ?? ""
		self.pathLabel.cell?.stringValue = process?.path ?? ""
	}
}

