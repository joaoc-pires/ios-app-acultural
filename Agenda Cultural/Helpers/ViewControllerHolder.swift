//
//  ViewControllerHolder.swift
//  Agenda Cultural
//
//  Created by Joao Pires on 09/12/2021.
//

import SwiftUI

struct ViewControllerHolder {
    
    weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
    
    static var defaultValue: ViewControllerHolder {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return ViewControllerHolder(value: windowScene?.keyWindow?.rootViewController)
    }
}

extension EnvironmentValues {
    
    var viewController: UIViewController? {
        get { return self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
}
