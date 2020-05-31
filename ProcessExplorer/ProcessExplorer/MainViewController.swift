//
//  ViewController.swift
//  ProcessExplorer
//
//  Created by Aleksandr Kucherenko on 30.05.2020.
//  Copyright © 2020 Aleksandr Kucherenko. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
		guard let splitViewController = segue.destinationController as? ProcessSplitViewController else { return }
		splitViewController.delegate = self
	}
}

//MARK: -
extension MainViewController: ProcessSplitViewControllerDelegate {
	func proccessSplitViewController(_ controller: ProcessSplitViewController, didUpdatedCountOfProcesses count: Int) {
		// TODO: Update UI with count
	}
}

