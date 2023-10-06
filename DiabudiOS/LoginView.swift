//
//  LoginView.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-05.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Username", text: $username)
                .padding()
                .border(Color.gray, width: 1)
                .cornerRadius(3)
            SecureField("Password", text: $password)
                .padding()
                .border(Color.gray, width: 1)
                .cornerRadius(3)
                .onAppear{
                    async {
                        await sessionManager.getCurrentAuthUser()
                    }
                }
            Button("Login", action: {
                async {
                    await sessionManager.login(
                        username: username,
                        password: password
                    )
                }
                
            })
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(3)
            
            Spacer()
            Button("Don't have an account? Sign up.", action: sessionManager.showSignUp)
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
