//
//  ContentView.swift
//  DragDropSections
//
//  Created by Cedric Trespeuch on 14/02/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var items = [
        "Section 1": [Item(id: "1", name: "Item 1"), Item(id: "2", name: "Item 2"), Item(id: "3", name: "Item 3")],
        "Section 2": [Item(id: "4", name: "Item 4"), Item(id: "5", name: "Item 5"), Item(id: "6", name: "Item 6")],
        "Section 3": [Item(id: "7", name: "Item 7"), Item(id: "8", name: "Item 8"), Item(id: "9", name: "Item 9")]
    ]
    
    @State private var itemIndex: Int = 10
    
    var body: some View {
        
        VStack {
            
            Text("**Drag & Drop Stack**")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle)
            
            Text("Delete, add and move your items within and between sections.\n\nIf a section is empty, you can also drag an item and drop it on section to move in.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline).italic()
                .padding(.vertical)
            
            DroppableStack(
                sections: $items,
                onTapItem: { itemId in
                    print("Clic on Item: \(itemId)")
                },
                addItem: { section in
                    withAnimation {
                        _ = items[section]?.append(Item(id: "\(itemIndex)", name: "New Item \(itemIndex)"))
                    }
                    itemIndex += 1
                    print("Add in: \(section)")
                }
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
