//
//  ImageDownloaderTests.swift
//  PokedexTests
//
//  Created by Vitor Costa on 30/09/24.
//

import XCTest

@testable import Pokedex

class ImageDownloaderTests: XCTestCase {
    private var sut: ImageDownloader!
    private var sessionMock: URLSessionMock!

    override func setUp() {
        sessionMock = URLSessionMock()
        sut = ImageDownloader(session: sessionMock)
    }

    override func tearDown() {
        sessionMock = nil
        sut = nil
    }

    func testDownloadImage_WithoutCache_ShouldReturnImage() {
        let image = UIImage(systemName: "checkmark")!
        sessionMock.data = image.pngData()
        sessionMock.response = HTTPURLResponse().makeURLResponseMock(with: 200)
        let expectation = self.expectation(description: "Download image should succeed without cache")
        let urlString = "https://example.com/image.png"
        sut.downloadImage(from: urlString) { result in
            switch result {
            case .success(let downloadedImage):
                XCTAssertNotNil(downloadedImage)
                XCTAssertEqual(downloadedImage.pngData()?.description, image.pngData()?.description)
            case .failure(let error):
                XCTFail("Unexpected error. Description: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error {
                XCTFail("Timeout expectation. Error: \(error)")
            }
        }
    }
    
    func testDownloadImage_WithCache_ShouldReturnCachedImage() {
        sessionMock.response = HTTPURLResponse().makeURLResponseMock(with: 200)
        let image = UIImage(systemName: "checkmark")!
        let urlString = "https://example.com/image.png"
        sut.cache(image: image, with: urlString)
        let expectation = self.expectation(description: "Download image should succeed from cache")
        sut.downloadImage(from: urlString) { result in
            switch result {
            case .success(let cachedImage):
                XCTAssertNotNil(cachedImage)
                XCTAssertEqual(cachedImage.pngData(), image.pngData())
                XCTAssertEqual(self.sessionMock.data, nil)
            case .failure(let error):
                XCTFail("Unexpected error. Description: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error {
                XCTFail("Timeout expectation. Error: \(error)")
            }
        }
    }
    
    func testDownloadImage_WithInvalidImageData_ShouldReturnInvalidImageData() {
        sessionMock.data = Data()
        sessionMock.response = HTTPURLResponse().makeURLResponseMock(with: 200)
        let expectation = self.expectation(description: "Download image should succeed without cache")
        let urlString = "https://example.com/image.png"
        sut.downloadImage(from: urlString) { result in
            switch result {
            case .success:
                XCTFail("Unexpected data.")
            case .failure(let error):
                XCTAssertEqual(error, .invalidImageData)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error {
                XCTFail("Timeout expectation. Error: \(error)")
            }
        }
    }
    
    func testDownloadImage_WithInvalidURL_ShouldReturnInvalidURL() {
        let expectation = self.expectation(description: "Download image should succeed without cache")
        sut.downloadImage(from: "") { result in
            switch result {
            case .success:
                XCTFail("Unexpected data.")
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error {
                XCTFail("Timeout expectation. Error: \(error)")
            }
        }
    }
}
