// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import XCTest
@testable import SnapShooter
import UIKit

final class SnapShooterTests: XCTestCase {
    class override func tearDown() {
        super.tearDown()
        deleteSnapshotFolder()
    }
    
    @MainActor
    func test_sameViewController_doesNotFail() {
        let vc1 = UIViewController()
        
        vc1.view.backgroundColor = .red
        
        let snapshot1 = vc1.snapshot()
        record(snapshot1)
        assert(snapshot1)
    }
    
    @MainActor
    func test_differentSnapshot_shouldFail() {
        let vc1 = UIViewController()
        
        vc1.view.backgroundColor = .red
        
        let snapshot1 = vc1.snapshot()
        
        record(snapshot1)
        
        vc1.view.backgroundColor = .blue
        let snapshot2 = vc1.snapshot()
        
        XCTExpectFailure("Snapshots are different, so assert should fail") {
            assert(snapshot2)
        }
    }
    
    @MainActor
    func test_recordedSnapshot_shouldMatch() {
        let vc1 = UIViewController()
        
        vc1.view.backgroundColor = .red
        
        let snapshot1 = vc1.snapshot(for: .iPhoneSE())
        
        record(snapshot1)
        assert(snapshot1)
    }
    
    @MainActor
    func test_assert_recordsSnapshotIfNoRecordedSnapshot() {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .red
        assert(vc1.snapshot(for: .iPhoneSE()))
    }
    
    // MARK: - Helpers
    private static func deleteSnapshotFolder(file: StaticString = #filePath) {
        let fileManager = FileManager.default
        let folder = URL(fileURLWithPath: "\(file)")
            .deletingLastPathComponent()
            .appendingPathComponent("Snapshots")
        
        try? fileManager.removeItem(at: folder)
    }
}
