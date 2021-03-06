//
//  BranchProvider.swift
//  Analytical_Example
//
//  Created by Erik Drobne on 17/10/2019.
//  Copyright © 2019 Unified Sense. All rights reserved.
//

import Branch
import UIKit

public class BranchProvider : BaseProvider<Branch>, AnalyticalProvider {
    
    public static let ShouldUseTestKey = "BranchShouldUseTestKey"
    public static let IsDebugEnabled = "IsDebugEnabledKey"
    public static let ShouldDelayStartSession = "ShouldDelayStartSessionKey"
    
    public var deepLinkHandler: (([AnyHashable: Any]?, Error?) -> Void)?
    
    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    
    public func setup(with properties: Properties?) {
        launchOptions = properties?[Property.Launch.options.rawValue] as? [UIApplication.LaunchOptionsKey: Any]
        
        if let shouldUseTestKey = properties?[BranchProvider.ShouldUseTestKey] as? Bool, shouldUseTestKey {
            Branch.setUseTestBranchKey(shouldUseTestKey)
        }
        
        instance = Branch.getInstance()
        
        let isDebugEnabled = properties?[BranchProvider.IsDebugEnabled] as? Bool ?? false
        
        if isDebugEnabled {
            instance.enableLogging()
        }
        
        let shouldDelayStartSession = properties?[BranchProvider.ShouldDelayStartSession] as? Bool ?? false
        
        if !shouldDelayStartSession {
            initSession()
        }
    }
    
    public func initSession() {
        instance.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: deepLinkHandler)
    }
    
    public func flush() {
    
    }
    
    public func reset() {
        
    }
    
    public func identify(userId: String, properties: Properties?) {
        instance.setIdentity(userId)
    }
    
    public func alias(userId: String, forId: String) {
        
    }
    
    public func set(properties: Properties) {
        
    }
    
    public func increment(property: String, by number: NSDecimalNumber) {
        
    }
    
    public override func update(event: AnalyticalEvent) -> AnalyticalEvent? {
        guard let event = super.update(event: event) else {
            return nil
        }
        
        return event
    }
    
    public override func event(_ event: AnalyticalEvent) {
        guard let event = update(event: event) else {
            return
        }
        
        guard let defaultName = DefaultEvent(rawValue: event.name), let branchEvent = branchEvent(for: defaultName) else {
            return
        }
        
        BranchEvent.standardEvent(branchEvent).logEvent()
        delegate?.analyticalProviderDidSendEvent(self, event: event)
    }
    
    public override func activate() {
        
    }
    
    private func branchEvent(for name: DefaultEvent) -> BranchStandardEvent? {
        switch name {
        case .startTrial:
            return .startTrial
        case .addedToCart:
            return .addToCart
        case .spendCredits:
            return .spendCredits
        case .purchase:
            return .purchase
        case .login:
            return .login
        case .share:
            return .share
        case .search:
            return .search
        case .achievedLevel:
            return .achieveLevel
        case .addedPaymentInfo:
            return .addPaymentInfo
        case .addedToWishlist:
            return .addToWishlist
        case .completedRegistration:
            return .completeRegistration
        case .completedTutorial:
            return .completeTutorial
        case .rating:
            return .rate
        case .unlockedAchievement:
            return .unlockAchievement
        case .subscribe:
            return .subscribe
        case .adImpression:
            return .viewAd
        case .adClick:
            return .clickAd
        case .viewItem:
            return .viewItem
        case .viewItemList:
            return .viewItems
        case .invite:
            return .invite
        default:
            return nil
        }
    }
}
