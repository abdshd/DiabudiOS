//
//  DiabudiOSApp.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-05.
//

import SwiftUI
import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin

@main
struct DiabudiOSApp: App {
    
    @ObservedObject var sessionManager = SessionManager()
    @StateObject var itemModel = ItemsViewModel()
    @ObservedObject var sugarModel = SugarViewModel()
    
     
    init() {
        configureAmplify()
//        Task {
//            await sessionManager.getCurrentAuthUser()
//            print(sessionManager.authState)
//
//        }
    }

     
     var body: some Scene {
         WindowGroup {
             switch sessionManager.authState {
             case .login:
                 LoginView()
                     .environmentObject(sessionManager)
                 
             case .signUp:
                 SignUpView()
                     .environmentObject(sessionManager)
                 
             case .confirmCode(let username):
                 ConfirmationView(username: username)
                     .environmentObject(sessionManager)
                 
             case .session(let user):
                 NavigationView{
                     SessionView(user: user)
                         .environmentObject(sessionManager)
                         .task {
                             await itemModel.listItems()
                             await sugarModel.listSugarData()
                             print("Done")
                         }
                 }
             }
         }
     }
     
     private func configureAmplify() {
         do {
             try Amplify.add(plugin: AWSCognitoAuthPlugin())
             let models = AmplifyModels()
             try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
             try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
             try Amplify.configure()
             print("Amplify configured successfully")
             
         } catch {
             print("could not initialize Amplify", error)
         }
     }
 }
