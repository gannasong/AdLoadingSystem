//
//  GADAdClientTests.swift
//  AdLoaderSystemTests
//
//  Created by SUNG HAO LIN on 2021/9/10.
//

import XCTest
import AdLoaderSystem
import GoogleMobileAds

class GADAdClientTests: XCTestCase {

  override func setUp() {
    super.setUp()
    GADMobileAdsStart()
  }

  func test_load_requestAdFromUnitID() {
    let sut = makeSUT()
    let exp = expectation(description: "Wait request ad completion.")


    var receivedNativeAd: GADNativeAd?
    var receivedError: Error?

    sut.laod { result in
      switch result {
      case let .success(nativeAd):
        receivedNativeAd = nativeAd
        print("✅ > GADAdClient received nativeAd: ", nativeAd)
      case let .failure(error):
        receivedError = error
        print("🛑 > GADAdClient request fail:: ", error.localizedDescription)
      }

      exp.fulfill()
    }

    wait(for: [exp], timeout: 5.0)

    XCTAssertNotNil(receivedNativeAd)
    XCTAssertNil(receivedError)
  }

  func test_load_requestAdWithErrorFromUnitID() {
    let sut = makeSUT(unitID: "error-unitID")
    let exp = expectation(description: "Wait request ad completion.")


    var receivedNativeAd: GADNativeAd?
    var receivedError: Error?

    sut.laod { result in
      switch result {
      case let .success(nativeAd):
        receivedNativeAd = nativeAd
        print("✅ > GADAdClient received nativeAd: ", nativeAd)
      case let .failure(error):
        receivedError = error
        print("🛑 > GADAdClient request fail:: ", error.localizedDescription)
      }

      exp.fulfill()
    }

    wait(for: [exp], timeout: 5.0)

    XCTAssertNil(receivedNativeAd)
    XCTAssertNotNil(receivedError)
  }

  // MARK: - Helpers

  private func makeSUT(unitID: String = "ca-app-pub-3940256099942544/3986624511") -> GADAdClient {
    let loader =  GADAdLoader(adUnitID: unitID,
                              rootViewController: FakeViewController(),
                              adTypes: [.native],
                              options: [])
    let sut = GADAdClient(loader: loader)
    return sut
  }

  private func GADMobileAdsStart() {
    GADMobileAds.sharedInstance().start(completionHandler: nil)
  }

  private class FakeViewController: UIViewController {}
}
