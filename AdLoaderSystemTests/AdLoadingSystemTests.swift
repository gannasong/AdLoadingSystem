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
    client.laod { [weak self] result in
      switch result {
      case let .success(nativeAd):
        self?.nativeAds.append(value: nativeAd)
      case let .failure(error):
        print("error: ", error.localizedDescription)
      }
    }
  }
}

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

    func complete(natvieAd: GADNativeAd, index: Int = 0) {
      messages[index](.success(natvieAd))
    }
  }
}
