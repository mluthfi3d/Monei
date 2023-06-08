//
//  ContentView.swift
//  Monei
//
//  Created by Muhammad Luthfi on 05/05/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            let newPocket = Pocket()
            PocketsView(openedPocket: newPocket)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
