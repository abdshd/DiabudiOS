//
//  SessionView.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-05.
//

import SwiftUI
import Amplify

struct SessionView: View {
    
    let user: AuthUser
    
    var body: some View {
        TabView {
            HomeView(user: user)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            ItemsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Items")
                }
                .tag(1)
            ProcessesView()
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Processes")
                }
                .tag(2)
        }
        .tabViewStyle(DefaultTabViewStyle())
    }
    
}

struct SessionView_Previews: PreviewProvider {
    private struct DummyUser: AuthUser {
        let userId: String = "1"
        let username: String = "dummy"
    }
    
    static var previews: some View {
        SessionView(user: DummyUser())
    }
}
