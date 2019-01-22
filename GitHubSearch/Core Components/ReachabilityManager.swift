//
//  ReachabilityManager.swift
//  Sublink
//
//  Created by Maksim on 10/18/17.
//  Copyright © 2017 Maksim. All rights reserved.
//

import Foundation

final class ReachabilityManager {
    
    private init() {}
    static let shared = ReachabilityManager()
    
    let reachability = Reachability()
    
    var connectionStatus: Reachability.Connection = .none
    
    var isNetworkAvailable: Bool {
        return connectionStatus != .none
    }
    
    @objc private  func reachabilityChanged(notification: Notification) {
        guard let reachability: Reachability = cast(notification.object) else { return }
        connectionStatus = reachability.connection
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged),
            name: .reachabilityChanged,
            object: reachability
        )
        
        try? reachability?.startNotifier()
    }
    
    func stopMonitoring() {
        reachability?.stopNotifier()
        
        NotificationCenter.default.removeObserver(
            self,
            name: .reachabilityChanged,
            object: reachability
        )
    }
    
}
