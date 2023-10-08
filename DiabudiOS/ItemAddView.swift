//
//  ItemAddView.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-07.
//

import SwiftUI

struct ItemAddView: View {
@ObservedObject var itemModel = ItemsViewModel()
    
    @State private var itemName: String = ""
    @State private var itemUnit: String = ""
    @State private var itemQuantity: Int = 0
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                Text("Name")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter a name", text: $itemName)
                    .textFieldStyle(.roundedBorder)
                Text("Unit")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter the unit", text: $itemUnit)
                    .textFieldStyle(.roundedBorder)
                Text("Quantity")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("Enter a quantity", text: Binding<String>(
                    get: { String(itemQuantity) },
                    set: { if let newValue = Int($0) {itemQuantity = newValue} }
                ))
                    .textFieldStyle(.roundedBorder)
                Spacer()
                Button("Create Item", action: {
                    async {
                        await itemModel.createItem(itemName, itemUnit, itemQuantity)
                        showAlert = true
                    }
                })
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 30)
            }
            .padding(.horizontal, 16)
        }
        .navigationBarTitle("Create Item", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Item Created"),
                message: Text("The item was created successfully"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ItemAddView_Previews: PreviewProvider {
    static var previews: some View {
        ItemAddView()
    }
}
