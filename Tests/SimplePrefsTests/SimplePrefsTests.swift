import XCTest
@testable import SimplePrefs

final class SimplePrefsTests: XCTestCase {
	
	var filePrefs: FilePreferencesExample {
		get { .shared }
		set { FilePreferencesExample.shared = newValue }
	}
	@available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *)
	var encryptedFilePrefs: EncryptedFilePreferencesExample {
		get { .shared }
		set { EncryptedFilePreferencesExample.shared = newValue }
	}
	var userDefaultsPrefs: UserDefaultsPreferencesExample {
		get { .shared }
		set { UserDefaultsPreferencesExample.shared = newValue }
	}
	
	//
	
	func testDefaultValues() {
		
		UserDefaultsPreferencesExample.CodingKeys.allCases.map { $0.rawValue }.forEach { key in
			UserDefaults.standard.removeObject(forKey: key)
		}
		
		XCTAssertEqual(filePrefs.age, nil)
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			XCTAssertEqual(encryptedFilePrefs.age, nil)
		}
		XCTAssertEqual(userDefaultsPrefs.age, nil)
		
		XCTAssertEqual(filePrefs.isDarkModeEnabled, false)
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			XCTAssertEqual(encryptedFilePrefs.isDarkModeEnabled, false)
		}
		XCTAssertEqual(userDefaultsPrefs.isDarkModeEnabled, false)
		
		XCTAssertEqual(filePrefs.person, Person(name: "John"))
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			XCTAssertEqual(encryptedFilePrefs.person, Person(name: "John"))
		}
		XCTAssertEqual(userDefaultsPrefs.person, Person(name: "John"))
	}
	
	func testNewValues() {
		
		let newAge: Int = 100
		let isDark = true
		let person = Person(name: "Daniel")
		
		filePrefs.age = newAge
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			encryptedFilePrefs.age = newAge
		}
		userDefaultsPrefs.age = newAge
		XCTAssertEqual(filePrefs.age, newAge)
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			XCTAssertEqual(encryptedFilePrefs.age, newAge)
		}
		XCTAssertEqual(userDefaultsPrefs.age, newAge)
		
		filePrefs.isDarkModeEnabled = isDark
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			encryptedFilePrefs.isDarkModeEnabled = isDark
		}
		userDefaultsPrefs.isDarkModeEnabled = isDark
		XCTAssertEqual(filePrefs.isDarkModeEnabled, isDark)
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			XCTAssertEqual(encryptedFilePrefs.isDarkModeEnabled, isDark)
		}
		XCTAssertEqual(userDefaultsPrefs.isDarkModeEnabled, isDark)
		
		filePrefs.person = person
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			encryptedFilePrefs.person = person
		}
		userDefaultsPrefs.person = person
		XCTAssertEqual(filePrefs.person, person)
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			XCTAssertEqual(encryptedFilePrefs.person, person)
		}
		XCTAssertEqual(userDefaultsPrefs.person, person)
	}
	
	func testSaveFilePreferences() {
		
		filePrefs.save()
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			encryptedFilePrefs.save()
		}
		
		XCTAssertNotNil(FilePreferencesExample.path)
		XCTAssertTrue(FileManager.default.fileExists(atPath: FilePreferencesExample.path!))
		
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			XCTAssertNotNil(EncryptedFilePreferencesExample.path)
			XCTAssertTrue(FileManager.default.fileExists(atPath: EncryptedFilePreferencesExample.path!))
		}
	}
	
	func testNewValuesAfterLoad() {
		
		filePrefs.synchronize()
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			encryptedFilePrefs.synchronize()
		}
		userDefaultsPrefs.synchronize()
		
		let newAge: Int = 100
		let isDark = true
		let person = Person(name: "Daniel")
		
		XCTAssertEqual(filePrefs.age, newAge)
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			XCTAssertEqual(encryptedFilePrefs.age, newAge)
		}
		XCTAssertEqual(userDefaultsPrefs.age, newAge)
		
		XCTAssertEqual(filePrefs.isDarkModeEnabled, isDark)
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			XCTAssertEqual(encryptedFilePrefs.isDarkModeEnabled, isDark)
		}
		XCTAssertEqual(userDefaultsPrefs.isDarkModeEnabled, isDark)
		
		XCTAssertEqual(filePrefs.person, person)
		if #available(iOS 13.0, OSX 10.15, watchOS 6.0, tvOS 13.0, *) {
			XCTAssertEqual(encryptedFilePrefs.person, person)
		}
		XCTAssertEqual(userDefaultsPrefs.person, person)
	}
	
	static var allTests = [
		("testDefaultValues", testDefaultValues),
		("testNewValues", testNewValues),
		("testSaveFilePreferences", testSaveFilePreferences),
		("testNewValuesAfterLoad", testNewValuesAfterLoad)
	]
}