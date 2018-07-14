//
//  ConnectionCoordinator.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 13.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import Foundation
import SystemConfiguration

class InternetConnection {
    private init() {}
}

extension InternetConnection {
    
    static func isConnected() -> Bool {
        
        var zeroAddress = sockaddr_in()
        var flags = SCNetworkReachabilityFlags()
        
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
}
