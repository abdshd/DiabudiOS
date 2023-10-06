//
//  SignUpView.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-05.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Username", text: $username)
                .padding()
                .border(Color.gray, width: 1)
                .cornerRadius(3)
            TextField("Email", text: $email)
                .padding()
                .border(Color.gray, width: 1)
                .cornerRadius(3)
            SecureField("Password", text: $password)
                .padding()
                .border(Color.gray, width: 1)
                .cornerRadius(3)
            Button("Sign Up", action: {
                async {
                    await sessionManager.signUp(
                        username: username,
                        password: password,
                        email: email
                    )
                    sessionManager.showConfirm(username: username)
                }
            })
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(3)
            
            
            
            Spacer()
            Button("Already have an account? Log in.", action: sessionManager.showLogin)
        }
        .padding()
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
