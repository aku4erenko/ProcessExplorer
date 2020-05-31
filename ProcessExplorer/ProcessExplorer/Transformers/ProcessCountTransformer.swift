//
//  ProcessCountFormatter.swift
//  ProcessExplorer
//
//  Created by Aleksandr Kucherenko on 31.05.2020.
//  Copyright © 2020 Aleksandr Kucherenko. All rights reserved.
//

import Cocoa

@objc
class ProcessCountTransformer: ValueTransformer {
	@objc
	override class func transformedValueClass() -> AnyClass {
		return NSString.self
	}
	
	@objc
	override class func allowsReverseTransformation() -> Bool {
		return false
	}
	
	@objc
	override func transformedValue(_ value: Any?) -> Any? {
		guard let number = value as? NSNumber else { return nil }
		
		let localizedFormat = NSLocalizedString("There is(are) %d process(es)", comment: "") as NSString
		return NSString.localizedStringWithFormat(localizedFormat, number.intValue)
	}
}
