//
//  SetView.swift
//  SET
//
//  Created by George Mapaya on 2022-06-06.
//

import SwiftUI

struct SetView: View {
    @EnvironmentObject private var game: Game
    
    var body: some View {
        Text("\(game.deck.count) cards")
            .padding()
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView()
            .environmentObject(Game())
    }
}
