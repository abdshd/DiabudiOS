//
//  ItemsView.swift
//  DiabudiOS
//
//  Created by Abdullah Shahid on 2023-10-05.
//

import SwiftUI
import Amplify

struct ItemsView: View {
    
    @ObservedObject var itemModel = ItemsViewModel()
    
    @State private var filterText = ""
    @State private var sortAscending = true
    
    var body: some View {
        VStack {
            List(itemModel.items, id: \.id) { item in
                NavigationLink(destination: ItemEditView(item: item, updateItem: {_ in
                    var _: Item
                })) {
                    ItemsRowView(item: item)
                }
            }
            .task {
                await itemModel.listItems()
            }
            .scrollContentBackground(.hidden)
            
            Rectangle()
                .fill(Color.clear)
                .frame(height: 10)
            
            NavigationLink(destination: ItemAddView()) {
                Text("Create Item")
            }
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
}

struct ItemsRowView: View {
    var item: Item
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.unit ?? "")
                    .font(.subheadline)
                Text(String(item.quantity ?? 0))
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
