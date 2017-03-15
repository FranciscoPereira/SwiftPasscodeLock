//
//  RemovePasscodeState.swift
//  PasscodeLock
//
//  Created by Kevin Seidel on 06/10/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct RemovePasscodeState: PasscodeLockStateType {
    public let title: String
    public let description: String
    public let isCancellableAction = false
    public var isTouchIDAllowed: Bool { return false }
    
    private var isNotificationSent = false
    
    fileprivate var incorrectPasscodeAttemptsKey = "incorrectPasscodeAttemps"
    private var incorrectPasscodeAttempts: Int {
        get {
            return UserDefaults.standard.integer(forKey: incorrectPasscodeAttemptsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: incorrectPasscodeAttemptsKey)
        }
    }
    
    init() {
        
        title = localizedStringFor("PasscodeLockEnterTitle", comment: "Enter passcode title")
        description = localizedStringFor("PasscodeLockEnterDescription", comment: "Enter passcode description")
    }
    
    public mutating func accept(passcode: String, from lock: PasscodeLockType) {
        if lock.repository.check(passcode: passcode) {
            
            lock.repository.delete()
            
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
