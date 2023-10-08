//
//  ItemsViewModel.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-07.
//

import Foundation
import Amplify

class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    
    func createItem(_ itemName: String, _ itemUnit: String, _ itemQuantity: Int) async {
        do {
            let item = Item(name: itemName, unit: itemUnit, quantity: itemQuantity)
            let result = try await Amplify.API.mutate(request: .create(item))
            switch result {
            case .success(let item):
                print("Successfully craeted the item: \(item)")
            case .failure(let graphQLError):
                print("Failed: \(graphQLError)")
            }
        } catch {
            print(error)
        }
    }
    
    func listItems() async {
        let request = GraphQLRequest<Item>.list(Item.self, limit: 100)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let fetchedItems):
                let listConversion = fetchedItems.map { $0 }
                DispatchQueue.main.async{
                    self.items = listConversion
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
    
    func updateItem(item: Item) async {
        do {
            let result = try await Amplify.API.query(request: .update(item))
            switch result {
            case .success(let item):
                print("Updated \(item)")
            case .failure(let error):
                print("Error: \(error)")
            }
        } catch let error as APIError {
            print("API Error: \(error)")
        } catch {
            print("Error: \(error)")
        }
    }
    
    func deleteItem(item: Item) async {
        do {
            let result = try await Amplify.API.query(request: .delete(item))
            switch result {
            case .success(_):
                print("Deleted")
            case .failure(let error):
                print("Error: \(error)")
            }
        } catch let error as APIError {
            print("API Error: \(error)")
        } catch {
            print("Error: \(error)")
        }
    }
}
