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
}

class AdLoadingSystemTests: XCTestCase {

  func test_init_nativeAdsIsEmpty() {
    let sut = AdLoadingSystem()

    XCTAssertTrue(sut.nativeAds.isEmpty)
  }
}
