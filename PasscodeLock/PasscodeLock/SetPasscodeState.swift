//
//  SetPasscodeState.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

public struct SetPasscodeState: PasscodeLockStateType {
    
    public let title: String
    public let description: String
    public let isCancellableAction = true
    public var isTouchIDAllowed = false
    
    init(title: String, description: String) {
        
        self.title = title
        self.description = description
    }
    
    init() {
        
        title = localizedStringFor("PasscodeLockSetTitle", comment: "Set passcode title")
        description = localizedStringFor("PasscodeLockSetDescription", comment: "Set passcode description")
    }
    
    public func accept(passcode: String, from lock: PasscodeLockType) {
        
        lock.changeState(ConfirmPasscodeState(passcode: passcode))

    }
}
