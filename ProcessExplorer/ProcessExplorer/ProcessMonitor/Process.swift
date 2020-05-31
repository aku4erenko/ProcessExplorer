//
//  File.swift
//  ProcessExplorer
//
//  Created by Aleksandr Kucherenko on 30.05.2020.
//  Copyright © 2020 Aleksandr Kucherenko. All rights reserved.
//

import Foundation
import Darwin


/// A model interface representing a process
public class Process: NSObject {
	
	/// Process identifier
	@objc let pid: pid_t
	
	/// Parent process identifier
	@objc let ppid: pid_t
	
	/// User identifier
	@objc let uid: uid_t
	
	/// A path to process' binary
	@objc let path: String
	
	init(pid: pid_t) {
		self.pid = pid
		
		// Get process info with pid
		var processInfo = kinfo_proc()
		var size = MemoryLayout<kinfo_proc>.stride
		var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, pid]
		let sResult = sysctl(&mib, u_int(mib.count), &processInfo, &size, nil, 0)
		if 0 == sResult {
			self.ppid = processInfo.kp_eproc.e_ppid
			self.uid = processInfo.kp_eproc.e_ucred.cr_uid
		} else {
			self.ppid = -1
			self.uid = 0
		}
		
		// Process path
		let pathBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(MAXPATHLEN))
		defer {
			pathBuffer.deallocate()
		}
		let pathLength = proc_pidpath(pid, pathBuffer, UInt32(MAXPATHLEN))
		if pathLength > 0 {
			self.path =  String(cString: pathBuffer)
		} else {
			self.path = ""
		}
	}
}
