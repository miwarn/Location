//
//  ContentView.swift
//  Location
//
//  Created by Michael Warnatz on 16.08.20.
//  Copyright © 2020 Michael Warnatz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var location: FetchLocation
    
    var body: some View {
        List {
            Toggle(isOn: $location.update) {
                Text("Position aktualisieren")
            }
            Text("Aktuelle Position")
            Text("Breite: \(location.latitude)")
            Text("Länge: \(location.longitude)")
            Text("Höhe: \(location.altitude)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(FetchLocation())
    }
}
