//
//  SugarViewModel.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-08.
//

import Foundation
import Amplify
import SwiftUI

struct SugarData: Identifiable {
    var id = UUID()
    var time: Date
    var sugarLevel: Int
}


class SugarViewModel: ObservableObject {
    @Published var data: [SugarData] = []
    
    func dateformat(_ dateTime: Temporal.Time) -> Date {
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.hour, .minute, .second], from: dateTime.foundationDate)
        return calendar.date(from: components)!
    }
    
    func getSugarStatus() -> String {
        guard let lastValue = data.last?.sugarLevel else {
            return "N/A"
        }
        if lastValue <= 90 {
            return "low"
        } else if lastValue >= 170 {
            return "high"
        }
        else {
            return "perfect"
        }
    }
    
    func getSugarColor() -> Color {
        guard let lastValue = data.last?.sugarLevel else {
            return .gray
        }
        if lastValue <= 90 {
            return .red
        } else if lastValue >= 170 {
            return .red
        }
        else {
            return .green
        }
    }
    
    func listSugarData() async {
        let request = GraphQLRequest<Sugar>.list(Sugar.self, limit: 100)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let fetchedSugar):
                print("Data:")
                print(fetchedSugar)
                let listConversion = fetchedSugar.map{ sugarItem in
                    return SugarData(time: dateformat(sugarItem.timestamp!), sugarLevel: sugarItem.sugar!)
                }
                let sortedData = listConversion.sorted(by: { $0.time < $1.time })
                DispatchQueue.main.async{
                    self.data = sortedData
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        } catch let error as APIError {
            print("API Error: \(error)")
        } catch {
            print("Error: \(error)")
        }
    }
    
    func createSugar() async {
        do {
            let sugar = Sugar(timestamp: Temporal.Time.now(), sugar: 102)
            let result = try await Amplify.API.mutate(request: .create(sugar))
            switch result {
            case .success(let sugar):
                print("Successfully craeted the sugar: \(sugar)")
            case .failure(let graphQLError):
                print("Failed: \(graphQLError)")
            }
        } catch {
            print(error)
        }
    }
    
}
