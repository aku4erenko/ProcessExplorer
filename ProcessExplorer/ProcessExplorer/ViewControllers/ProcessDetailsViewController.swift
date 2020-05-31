//
//  ProcessDetailsViewController.swift
//  ProcessExplorer
//
//  Created by Aleksandr Kucherenko on 31.05.2020.
//  Copyright © 2020 Aleksandr Kucherenko. All rights reserved.
//

import Cocoa

class ProcessDetailsViewController: NSViewController {
	@IBAction func killProcess(_ sender: Any) {
		guard let process = representedObject as? Process else { return }
		
		// TODO: Authorise operartion, SFAuthorization
		 kill(process.pid, SIGKILL)
	}
}

