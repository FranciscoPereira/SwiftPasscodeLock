//
//  EnterPasscodeState.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public let PasscodeLockIncorrectPasscodeNotification = Notification.Name("passcode.lock.incorrect.passcode.notification")

public struct EnterPasscodeState: PasscodeLockStateType {
    
    public let title: String
    public let description: String
    public let isCancellableAction: Bool
    public var isTouchIDAllowed = true
    
    fileprivate var incorrectPasscodeAttemptsKey = "incorrectPasscodeAttemps"
    private var incorrectPasscodeAttempts: Int {
        get {
            return UserDefaults.standard.integer(forKey: incorrectPasscodeAttemptsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: incorrectPasscodeAttemptsKey)
        }
    }
    fileprivate var isNotificationSent = false
    
    init(allowCancellation: Bool = false) {
        
        isCancellableAction = allowCancellation
        title = localizedStringFor("PasscodeLockEnterTitle", comment: "Enter passcode title")
        description = localizedStringFor("PasscodeLockEnterDescription", comment: "Enter passcode description")
    }
    
    public mutating func accept(passcode: String, from lock: PasscodeLockType) {
        if lock.repository.check(passcode: passcode) {
        
            lock.delegate?.passcodeLockDidSucceed(lock)
            
            incorrectPasscodeAttempts = 0
        
        } else {
        
            incorrectPasscodeAttempts += 1
        
            if incorrectPasscodeAttempts >= lock.configuration.maximumInccorectPasscodeAttempts {
            
                postNotification()
            }
        
            lock.delegate?.passcodeLockDidFail(lock)
        }
    }
    
    fileprivate mutating func postNotification() {
        
        guard !isNotificationSent else { return }
        
        NotificationCenter.default.post(name: PasscodeLockIncorrectPasscodeNotification, object: nil)
        
        isNotificationSent = true
    }
}
