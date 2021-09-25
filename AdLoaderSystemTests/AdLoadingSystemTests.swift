//
//  AdLoadingSystemTests.swift
//  AdLoaderSystemTests
//
//  Created by SUNG HAO LIN on 2021/9/10.
//

import XCTest
import AdLoaderSystem
import SimpleLinkedList
import GoogleMobileAds

class AdLoadingSystem {
  var nativeAds = SimpleLinkedList<GADNativeAd>()
  let client: AdClient

  init(client: AdClient) {
    self.client = client
  }

  func requestAd() {
    client.laod { _ in }
  }
}

class AdLoadingSystemTests: XCTestCase {

  func test_init_nativeAdsIsEmpty() {
    let (sut, _) = makeSUT()

    XCTAssertTrue(sut.nativeAds.isEmpty)
  }

  func test_request_requestAdsFromSystem() {
    let (sut, client) = makeSUT()

    sut.requestAd()
    XCTAssertEqual(client.requestCounts, 1)

    sut.requestAd()
    XCTAssertEqual(client.requestCounts, 2)
  }

  // MARK: - Helper

  private func makeSUT() -> (sut: AdLoadingSystem, client: AdClientSpy) {
    let client = AdClientSpy()
    let sut = AdLoadingSystem(client: client)
    return (sut, client)
  }

  private class AdClientSpy: AdClient {
    private var messages = [((AdResult) -> Void)]()

    var requestCounts: Int {
      return messages.count
    }

    func laod(completion: @escaping (AdResult) -> Void) {
      messages.append(completion)
    }
  }
}
