//
//  AppDelegate.swift
//  ProcessExplorer
//
//  Created by Aleksandr Kucherenko on 30.05.2020.
//  Copyright © 2020 Aleksandr Kucherenko. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	override init() {
		super.init()
		
		// Register value transformer
		let transformer = ProcessCountTransformer()
		ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName("ProcessCountTransformer"))
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

