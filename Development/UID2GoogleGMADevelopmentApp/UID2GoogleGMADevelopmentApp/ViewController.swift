//
//  ViewController.swift
//  UID2GoogleGMADevelopmentApp
//
//  See: https://github.com/googleads/googleads-mobile-ios-examples/tree/main/Swift/admanager/AdManagerRewardedInterstitialExample
//
//  Created by Brad Leege on 4/12/23.
//

import GoogleMobileAds
import UID2
import UIKit

class GameViewController: UIViewController, GADFullScreenContentDelegate {

  private enum GameState: Int {
    case notStarted
    case playing
    case paused
    case ended
  }

  /// The game length.
  private static let gameLength = 5

  /// The time length before an ad shows.
  private static let adIntroLength = 3.0

  /// The rewarded interstitial ad.
  private var rewardedInterstitialAd: GADRewardedInterstitialAd?

  /// The countdown timer.
  private var timer: Timer?

  /// The amount of time left in the game.
  private var timeLeft = gameLength

  /// Number of coins the user has earned.
  private var coinCount = 0

  /// The state of the game.
  private var gameState = GameState.notStarted

  /// The countdown timer label.
  @IBOutlet weak var gameText: UILabel!

  /// The play again button.
  @IBOutlet weak var playAgainButton: UIButton!

  /// Text that indicates current coin count.
  @IBOutlet weak var coinCountLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Pause game when application enters background.
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(GameViewController.pauseGame),
      name: UIApplication.didEnterBackgroundNotification, object: nil)

    // Resume game when application becomes active.
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(GameViewController.resumeGame),
      name: UIApplication.didBecomeActiveNotification, object: nil)

    startNewGame()
  }

  // MARK: - Game Logic

  private func startNewGame() {
    if rewardedInterstitialAd == nil {
      loadRewardedInterstitialAd()
    }

    gameState = .playing
    timeLeft = GameViewController.gameLength
    playAgainButton.isHidden = true
    updateTimeLeft()
    timer = Timer.scheduledTimer(
      timeInterval: 1.0,
      target: self,
      selector: #selector(GameViewController.decrementTimeLeft(_:)),
      userInfo: nil,
      repeats: true)
  }

  private func loadRewardedInterstitialAd() {
    let request = GAMRequest()
    GADRewardedInterstitialAd.load(
      withAdUnitID: "/21775744923/example/rewarded_interstitial", request: request
    ) { (ad, error) in
      if let error = error {
        print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
        self.playAgainButton.isHidden = false
        return
      }
      self.rewardedInterstitialAd = ad
      self.rewardedInterstitialAd?.fullScreenContentDelegate = self
    }
  }

  private func updateTimeLeft() {
    gameText.text = "\(timeLeft) seconds left!"
  }

  @objc private func decrementTimeLeft(_ timer: Timer) {
    timeLeft -= 1
    updateTimeLeft()
    if timeLeft == 0 {
      endGame()
    }
  }

  private func earnCoins(_ coins: NSInteger) {
    coinCount += coins
    coinCountLabel.text = "Coins: \(self.coinCount)"
  }

  @objc private func pauseGame() {
    guard gameState == .playing else {
      return
    }
    gameState = .paused

    // Prevent the timer from firing while app is in background.
    timer?.invalidate()
    timer = nil
  }

  @objc private func resumeGame() {
    guard gameState == .paused else {
      return
    }
    gameState = .playing

    updateTimeLeft()
    // Set the timer to start firing again.
    timer = Timer.scheduledTimer(
      timeInterval: 1.0,
      target: self,
      selector: #selector(GameViewController.decrementTimeLeft(_:)),
      userInfo: nil,
      repeats: true)
  }

  private func endGame() {
    gameState = .ended
    self.earnCoins(1)
    timer?.invalidate()
    timer = nil

    var adCanceled = false

    let alert = UIAlertController(
      title: "Game Over!",
      message:
        "Watch an ad for 10 more coins. Video starting in \(Int(GameViewController.adIntroLength)) seconds",
      preferredStyle: .alert)
    let alertAction = UIAlertAction(
      title: "No, thanks",
      style: .cancel
    ) { action in
      adCanceled = true
      self.playAgainButton.isHidden = false
    }
    alert.addAction(alertAction)
    self.present(alert, animated: true) {
      DispatchQueue.main.asyncAfter(deadline: .now() + GameViewController.adIntroLength) {
        self.dismiss(animated: true) {
          if !adCanceled {
            self.showRewardedInterstitialAd()
          }
        }
      }
    }
  }

  private func showRewardedInterstitialAd() {
    guard let ad = self.rewardedInterstitialAd else {
      print("Ad wasn't ready")
      return
    }
    ad.present(fromRootViewController: self) {
      let reward = ad.adReward
      print(
        "Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)"
      )
      self.earnCoins(reward.amount.intValue)
    }
  }

  // MARK: - Interstitial Button Actions

  @IBAction func playAgain(_ sender: AnyObject) {
    startNewGame()
  }

  // MARK: - GADFullScreenContentDelegate

  func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Ad did present full screen content.")
  }

  func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error)
  {
    print("Ad failed to present full screen content with error \(error.localizedDescription).")
    self.rewardedInterstitialAd = nil
    self.playAgainButton.isHidden = false
  }

  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Ad did dismiss full screen content.")
    self.rewardedInterstitialAd = nil
    self.playAgainButton.isHidden = false
  }

  // MARK: - deinit

  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.removeObserver(
      self,
      name: UIApplication.didBecomeActiveNotification, object: nil)
  }

}



//class ViewController: UIViewController {
//
//    /// The banner view.
//    @IBOutlet weak var bannerView: GADBannerView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        Task {
//            await loadUID2Identity()
//            let versionNumber = GADMobileAds.sharedInstance().versionNumber
//            print("Google Mobile Ads SDK version: \(versionNumber.majorVersion).\(versionNumber.minorVersion).\(versionNumber.patchVersion)")
//            bannerView.adUnitID = "/217152209/secure_signals"
//            bannerView.rootViewController = self
//            bannerView.load(GADRequest())
//        }
//    }
//
//    private func loadUID2Identity() async {
//
//        do {
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//
//            // Sample UID2Identity data
//            let uid2IdentityData = try AppDataLoader.load(fileName: "uid2identity", fileExtension: "json")
//            let uid2IdentityFromFile = try decoder.decode(UID2Identity.self, from: uid2IdentityData)
//
//            // Emulate A UID2Identity With Valid Times
//            let identityExpires = Date(timeIntervalSinceNow: 60 * 60).millisecondsSince1970
//            let refreshFrom = Date(timeIntervalSinceNow: 60 * 40).millisecondsSince1970
//            let refreshExpires = Date(timeIntervalSinceNow: 60 * 50).millisecondsSince1970
//
//            let uid2Identity = UID2Identity(advertisingToken: uid2IdentityFromFile.advertisingToken,
//                                            refreshToken: uid2IdentityFromFile.refreshToken,
//                                            identityExpires: identityExpires,
//                                            refreshFrom: refreshFrom,
//                                            refreshExpires: refreshExpires,
//                                            refreshResponseKey: uid2IdentityFromFile.refreshResponseKey)
//
//            await UID2Manager.shared.setIdentity(uid2Identity)
//        } catch {
//            print("Error loading UID2Identity")
//        }
//
//    }
//
//}
