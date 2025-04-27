//
//  AppDI.swift
//  FirstApp
//
//  Created by Christos Condrea on 8/2/25.
//

import Swinject

@MainActor public protocol AppDI {
    func getContainer() -> Container
}
