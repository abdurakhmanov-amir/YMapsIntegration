//
//  TaskCompletionSource.swift
//  YMapsIntergation
//
//  Created by Amir on 20.03.2025.
//

import Foundation

class SimpleTaskCompletionSource {
    private var _id : UUID
    private let _notificationName : Notification.Name
    
    init() {
        _id = UUID()
        _notificationName = Notification.Name("\(_id.uuidString)_taskCompletionNotification")
    }
    
    func WaitForCompletion() async {
        for await _ in NotificationCenter.default.notifications(named: _notificationName) {
            break
        }
    }
    
    func SetResult() {
        NotificationCenter.default.post(name: _notificationName, object: nil)
    }
}

class TaskCompletionSource<T> {
    private let _id : UUID
    private let _notificationName : Notification.Name
    private var _result : T?
    
    init() {
        _id = UUID()
        _notificationName = Notification.Name("\(_id.uuidString)_taskCompletionNotification")
    }
    
    func WaitForCompletion() async -> T {
        for await _ in NotificationCenter.default.notifications(named: _notificationName) {
            break
        }
        
        return _result!
    }
    
    func SetResult(_ result: T) {
        _result = result
        NotificationCenter.default.post(name: _notificationName, object: nil)
    }
}
