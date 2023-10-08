//
//  ItemEditView.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-07.
//

import SwiftUI

struct ItemEditView: View {
    @ObservedObject var itemModel = ItemsViewModel()
    
    @State private var itemName: String
    @State private var itemUnit: String
    @State private var itemQuantity: Int
    @State private var showAlert = false
    @State private var showDeleteConfirmation = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var item: Item
    
    var updateItem: (Item) -> Void
    
    init(item: Item, updateItem: @escaping (Item) -> Void) {
        self.item = item
        self._itemName = State(initialValue: item.name)
        self._itemUnit = State(initialValue: item.unit ?? "")
        self._itemQuantity = State(initialValue: item.quantity ?? 0)
        self.updateItem = updateItem
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                Text("Name")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Item Name", text: $itemName)
                    .textFieldStyle(.roundedBorder)
                Text("Unit")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Item Unit", text: $itemUnit)
                    .textFieldStyle(.roundedBorder)
                Text("Quantity")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Item Quantity", text: Binding<String>(
                    get: { String(itemQuantity) },
                    set: { if let newValue = Int($0) { itemQuantity = newValue } }
                ))
                .textFieldStyle(.roundedBorder)
                Button("Update Item", action: {
                    var updatedItem = item
                    updatedItem.name = itemName
                    updatedItem.unit = itemUnit
                    updatedItem.quantity = itemQuantity
                    
                    updateItem(updatedItem)
                    
                    async {
                        await itemModel.updateItem(item: updatedItem)
                        DispatchQueue.main.async {
                            showAlert = true
                            print("updatingin")
                        }
                    }
                })
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                DeleteButton {
                    async {
                        await itemModel.deleteItem(item: item)
                        showDeleteConfirmation = true
                    }
                }
                
            }
            .padding(.horizontal, 16)
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Item"),
                    message: Text("Are you sure you want to delete this item?"),
                    primaryButton: .destructive(Text("Yes")) {
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationBarTitle("Edit Item", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Item Updated"),
                message: Text("The item has been updated successfully."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


struct DeleteButton: View {
    var action: () -> Void
    
    var body: some View {
        Button("Delete Item", action: {
            action()
        })
        .frame(maxWidth: .infinity)
        .padding()
        .background(.red)
        .foregroundColor(.white)
        .cornerRadius(10)
        
        Rectangle()
            .fill(Color.clear)
            .frame(height: 30)
    }
}
