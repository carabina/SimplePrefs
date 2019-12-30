/*The MIT License (MIT)

Copyright (c) 2019 Daniel Illescas Romero

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation

/// Base protocol for preferences
protocol Preferences: Codable {
	
	static var shared: Self { get set }
	
	init()
	
	func save() -> Bool
	func synchronize()
	mutating func saving(_ closure: (inout Self) -> Void)
	mutating func synchronizing(_ closure: (inout Self) -> Void)
	
	static func _loadedPreferences() -> Self?
}

extension Preferences {

	/// Saves preferences and loads them
	func synchronize() {
		_ = save()
		Self.shared = Self._loadedPreferences() ?? .init()
	}
	
	mutating func saving(_ closure: (inout Self) -> Void) {
		closure(&self)
		_ = save()
	}
	
	mutating func synchronizing(_ closure: (inout Self) -> Void) {
		closure(&self)
		synchronize()
	}
}