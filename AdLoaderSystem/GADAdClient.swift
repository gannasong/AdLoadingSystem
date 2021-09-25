//
//  GADAdClient.swift
//  AdLoaderSystem
//
//  Created by SUNG HAO LIN on 2021/9/10.
//

import Foundation
import GoogleMobileAds

public protocol AdClient {
  typealias AdResult = Result<GADNativeAd, GADAdClient.AdError>

  func laod(completion: @escaping (AdResult) -> Void)
}

public class GADAdClient: NSObject, AdClient {
  private let loader: GADAdLoader
  private var receivedAdResult: ((AdResult) -> Void)?

  public enum AdError: Swift.Error {
    case noAdToShow
  }

  private let adRequest: GADRequest = {
    let adRequest = GADRequest()
    let extras = GADExtras()
    extras.additionalParameters = ["npa": "1"]
    adRequest.register(extras)
    return adRequest
  }()

  // MARK: - Initialization

  public init(loader: GADAdLoader) {
    self.loader = loader
    super.init()
    self.loader.delegate = self
  }

  // MARK: - Public Methods
  
  public func laod(completion: @escaping (AdResult) -> Void) {
    loader.load(adRequest)

    receivedAdResult = { result in
      completion(result)
    }
  }
}

extension GADAdClient: GADAdLoaderDelegate {
  public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    print("❌ error: ", error.localizedDescription)
    receivedAdResult?(.failure(.noAdToShow))
  }
}

extension GADAdClient: GADNativeAdLoaderDelegate {
  public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
    receivedAdResult?(.success(nativeAd))
  }
}
