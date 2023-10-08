//
//  SettingsView.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-06.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @Binding var isSettingsVisible: Bool
    
    var body: some View {
        VStack{
            Text("Settings")
            Button("Sign Out", action: {
                async {
                    await sessionManager.signOutLocally()
                }
                isSettingsVisible.toggle()
            })
            .padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isSettingsVisible: .constant(false))
    }
}
