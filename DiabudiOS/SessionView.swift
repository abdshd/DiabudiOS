//
//  SessionView.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-05.
//

import Amplify
import SwiftUI

struct SessionView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    let user: AuthUser
    
    var body: some View {
        VStack {
            Spacer()
            Text("You signed in as \(user.username) using Amplify!! Welcome to Diabud!")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                
            Spacer()
            Button("Sign Out", action: {
                async {
                    await sessionManager.signOutLocally()
                }
            })
        }
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
