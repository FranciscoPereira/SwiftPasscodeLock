//
//  ChangePasscodeState.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct ChangePasscodeState: PasscodeLockStateType {
    
    public let title: String
    public let description: String
    public let isCancellableAction = true
    public var isTouchIDAllowed = false
    
    init() {
        
        title = localizedStringFor("PasscodeLockChangeTitle", comment: "Change passcode title")
        description = localizedStringFor("PasscodeLockChangeDescription", comment: "Change passcode description")
    }
    
    public func accept(passcode: String, from lock: PasscodeLockType) {
        
        if lock.repository.check(passcode: passcode) {
        
            lock.changeState(SetPasscodeState())
        
        } else {
        
            lock.delegate?.passcodeLockDidFail(lock)
        }
    }
}
