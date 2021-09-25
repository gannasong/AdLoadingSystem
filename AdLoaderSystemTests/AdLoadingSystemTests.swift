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

class AdLoadingSystemTests: XCTestCase {

  func test_init_nativeAdsIsEmpty() {
    let (sut, _) = makeSUT()

    XCTAssertTrue(sut.nativeAds.isEmpty)
  }

  func test_requestAd_requestAdsFromSystem() {
    let (sut, client) = makeSUT()

    sut.requestAd()
    XCTAssertEqual(client.requestCounts, 1)

    sut.requestAd()
    XCTAssertEqual(client.requestCounts, 2)
  }

  func test_requestAd_deliverAdOnClientSuccess() {
    let (sut, client) = makeSUT()
    let nativeAd = GADNativeAd()

    sut.requestAd()
    client.complete(natvieAd: nativeAd)

    XCTAssertEqual(sut.nativeAds.first?.value, nativeAd)
  }

  func test_getAd_getNativeAdFromList() {
    let (sut, client) = makeSUT()
    let deliverAd = GADNativeAd()
    sut.requestAd()
    client.complete(natvieAd: deliverAd)

    let receivedAd = sut.getNativeAd()

    XCTAssertEqual(receivedAd, deliverAd)
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

    func complete(with error: GADAdClient.AdError, at index: Int = 0) {
      messages[index](.failure(.noAdToShow))
    }

    func complete(natvieAd: GADNativeAd, index: Int = 0) {
      messages[index](.success(natvieAd))
    }
  }
}
