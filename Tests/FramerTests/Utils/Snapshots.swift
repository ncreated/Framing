import UIKit
import XCTest

struct ReferenceImage {
    let url: URL

    private init(path: String, file: StaticString = #filePath) {
        self.url = URL(fileURLWithPath: "\(file)", isDirectory: false)
            .deletingLastPathComponent()
            .appendingPathComponent(path)
    }

    /// Creates reference image in folder with given name.
    /// The folder will be placed next to current file.
    /// The image will be named by the name of current test.
    static func inFolder(named folderName: String, file: StaticString = #filePath, function: StaticString = #function) -> ReferenceImage {
        return ReferenceImage(path: "\(folderName)/\(function).png", file: file)
    }
}

/// Compares image against reference file OR updates reference file with image data (if `record == true`).
///
/// It raises `XCTest` assertion failure if image is different than reference.
///
/// - Parameters:
///   - image: the image to compare OR record
///   - referenceImage: the reference file to compare against
///   - record: if `true`, then reference file will be created / overwritten with `image` data
///   - file: `#filePath` for eventual `XCTest` assertion failure
///   - line: `#line` for eventual `XCTest` assertion failure
internal func compare(
    image: UIImage,
    referenceImage: ReferenceImage,
    record: Bool,
    file: StaticString = #filePath,
    line: UInt = #line
) throws {
    if record {
        let directoryURL = referenceImage.url.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        let data = try XCTUnwrap(image.pngData(), "Failed to create `pngData()` for `image`", file: file, line: line)
        try data.write(to: referenceImage.url)
    } else {
        let oldImageData = try Data(contentsOf: referenceImage.url)
        let oldImage = try XCTUnwrap(UIImage(data: oldImageData), "Failed to read reference image", file: file, line: line)
        if let difference = compare(oldImage, image, precision: 1, perceptualPrecision: 1) {
            XCTFail(difference, file: file, line: line)
        }
    }
}
