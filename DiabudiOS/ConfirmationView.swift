//
//  ConfirmationView.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-05.
//
import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var confirmationCode = ""
    
    let username: String
    
    var body: some View {
        VStack {
            Text("Username: \(username)")
            TextField("Confirmation Code", text: $confirmationCode)
                .padding()
                .border(Color.gray, width: 1)
                .cornerRadius(3)
            Button("Confirm", action: {
                async {
                    await sessionManager.confirm(
                        for: username,
                        with: confirmationCode
                    )
                }
                
            })
            .padding()
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(3)
        }
        .padding()
    }
    
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "Abdullah")
    }
}
