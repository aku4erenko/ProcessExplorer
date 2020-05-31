//
//  ProcessMonitor.swift
//  ProcessExplorer
//
//  Created by Aleksandr Kucherenko on 30.05.2020.
//  Copyright © 2020 Aleksandr Kucherenko. All rights reserved.
//

import Cocoa

/// A service interface to track active processes or terminated ones.
final public class ProcessMonitor: NSObject {
	public enum Event {
		case launch([Process])
		case terminate(Set<pid_t>)
	}
	public typealias EventHandler = (Event) -> ()
	// MARK: Properties
	private var eventHandler: EventHandler?
	
	private var pollingTimer: Timer? {
		willSet {
			pollingTimer?.invalidate()
		}
	}
	
	private var activePIDs = Set<pid_t>()
	// MARK: -
	deinit {
		pollingTimer?.invalidate()
	}
	
	// MARK: -
	public func start(eventHandler: @escaping EventHandler) {
		self.eventHandler = eventHandler
		
		verifyActiveProcesses()

		// Schedule polling timer
		pollingTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(pollingTimerDidFire(_:)), userInfo: nil, repeats: true)
	}
	
	public func stop() {
		pollingTimer = nil
	}
	
	// MARK: -
	private func verifyActiveProcesses() {
		// Resolve availilabe process ids
		let resolvedPIDs = resolveActivePIDs()
		
		do { // Determine launched (new) processes
			var launchedProcesses = [Process]()
			let launchedPIDS = resolvedPIDs.subtracting(activePIDs)
			for pid in launchedPIDS {
				launchedProcesses.append(Process(pid: pid))
			}
			
			if !launchedProcesses.isEmpty {
				eventHandler?(.launch(launchedProcesses))
			}
		}
		
		do { // Determine terminated processes
			let terminatedPIDs = activePIDs.subtracting(resolvedPIDs)
			if !terminatedPIDs.isEmpty {
				eventHandler?(.terminate(terminatedPIDs))
			}
		}
		
		// Synchronize
		activePIDs = resolvedPIDs
	}
	
	private func resolveActivePIDs() -> Set<pid_t> {
		
		var count = proc_listallpids(nil, 0)
		guard count > 0 else { return [] }
		var result = Set<pid_t>()
		var buffer = UnsafeMutablePointer<pid_t>.allocate(capacity: Int(count))
		defer {
			buffer.deallocate()
		}
		
		count = proc_listallpids(buffer, Int32(MemoryLayout<pid_t>.size) * count)
		
		for i in 0..<Int(count) {
			let pid = buffer[i]
			result.insert(pid)
		}
				
		return result
	}
	
	@objc
	private func pollingTimerDidFire(_ timer: Timer) {
		verifyActiveProcesses()
	}
}
