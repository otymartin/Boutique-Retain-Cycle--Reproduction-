//
//  Boutique_Retain_CycleApp.swift
//  Boutique Retain Cycle
//
//  Created by MBO on 4/18/24.
//

import SwiftUI

enum CurrentView {
    case signIn, content
}

struct SignIn: View {
    @Binding var state: CurrentView
        Button {
            state = .content
        } label: {
            Text("Sign In")
        }
    }
}


@main
struct Boutique_Retain_CycleApp: App {
    @State var state: CurrentView = .signIn
    
    var body: some Scene {
        WindowGroup {
            switch state {
            case .content:
                ContentView(state: $state)
            case .signIn:
                SignIn(state: $state)
            }
        }
    }
}
