//
//  AdLoadingSystem.swift
//  AdLoaderSystem
//
//  Created by SUNG HAO LIN on 2021/9/25.
//

import Foundation
import SimpleLinkedList
import GoogleMobileAds

public class AdLoadingSystem {
  public private(set) var nativeAds = SimpleLinkedList<GADNativeAd>()
  private let client: AdClient

  public init(client: AdClient) {
    self.client = client
  }

  public func getNativeAd() -> GADNativeAd? {
    if nativeAds.isEmpty {
      requestAd()
      return nil
    } else {
      return nativeAds.removeFirst()
    }
  }

  public func requestAd() {
    client.laod { [weak self] result in
      switch result {
      case let .success(nativeAd):
        self?.nativeAds.append(value: nativeAd)
      case let .failure(error):
        // we do not care error message
        print("error: ", error.localizedDescription)
      }
    }
  }
}
