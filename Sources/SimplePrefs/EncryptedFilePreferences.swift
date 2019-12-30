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

#if canImport(CryptoKit)
import Foundation
import CryptoKit

/// Saves preferences as en encrypted JSON file
protocol EncryptedFilePreferences: FilePreferences {
	static var dataKey: Data { get }
}
@available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *)
extension EncryptedFilePreferences {
	
	private static var key: SymmetricKey {
		SymmetricKey(data: Self.dataKey)
	}
	
	/// File name including extension
	static var fileName: String {
		return "\(Self.self).enc"
	}
	
	@discardableResult
	func save() -> Bool {
		guard let encriptedData = try? JSONEncoder().encode(self), let path = Self.path else {
			return false
		}
		
		if let encryptedData = try? ChaChaPoly.seal(encriptedData, using: Self.key).combined {
			return FileManager.default.createFile(atPath: path, contents: encryptedData, attributes: nil)
		}
		return false
	}
	
	static func _loadedPreferences() -> Self? {
		if let path = Self.path,
			let encryptedData = FileManager.default.contents(atPath: path),
			let sealedBox = try? ChaChaPoly.SealedBox(combined: encryptedData),
			let decryptedData = try? ChaChaPoly.open(sealedBox, using: Self.key),
			let instance = try? JSONDecoder().decode(Self.self, from: decryptedData) {
				
			return instance
		}
		return nil
	}
}
#endif
