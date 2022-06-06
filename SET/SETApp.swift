//
//  SETApp.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import SwiftUI

@main
struct SETApp: App {
    @StateObject private var game = Game()
    
    var body: some Scene {
        WindowGroup {
            SetView()
                .environmentObject(game)
        }
    }
}
