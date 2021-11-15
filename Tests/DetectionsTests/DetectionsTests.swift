import XCTest
@testable import Detections

final class DetectionsTests: XCTestCase {
    func testEmptyImage() throws {
        FaceDetection.imageProcessing(UIImage()) { result in
            switch result {
            case .success(let message) :
                XCTAssertEqual("Success", message)
            case .failure(let error):
                XCTAssertEqual(faceErrors.noCGImage, error)
            }
        }
    }
}
