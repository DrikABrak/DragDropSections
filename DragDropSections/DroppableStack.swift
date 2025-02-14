//
//  DroppableStack.swift
//  DragDropSections
//
//  Created by Cedric Trespeuch on 14/02/2025.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    var id: String
    var name: String
}

struct DroppableStack: View {
    
    @Binding var sections: [String : [Item]]
    let onTapItem: ((String) -> Void)?
    let addItem: ((String) -> Void)?
    
    @State private var draggingItem: Item? = nil
    @State private var draggingSection: String? = nil
    
    init(sections: Binding<[String : [Item]]>, onTapItem: ((String) -> Void)? = nil, addItem: ((String) -> Void)? = nil) {
        self._sections = sections
        self.onTapItem = onTapItem
        self.addItem = addItem
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 0) {
                
                ForEach(sections.keys.sorted(), id: \.self) { section in
                    Section(
                        header:
                            HStack {
                                
                                Text(section)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title3).bold()
                                    .padding(.leading)
                        
                                Image(systemName: "plus.circle")
                                    .frame(width: 40, height: 40)
                                    .font(.largeTitle)
                                    .padding(.trailing)
                                    .onTapGesture {
                                        self.addItem?(section)
                                    }
                        
                            }
                            .frame(height: 60)
                            .background(Color.indigo)
                            .cornerRadius(8)
                            .onDrop(of: [.text], delegate: ItemDropSectionDelegate(
                                dropSection: section,
                                dragItem: $draggingItem,
                                dragSection: $draggingSection,
                                sections: $sections
                            ))
                    ) {
                        ForEach(self.sections[section]!, id: \.self) { item in
                            HStack {
                                
                                Image(systemName: "minus.circle")
                                    .frame(width: 40, height: 40)
                                    .font(.largeTitle)
                                    .onTapGesture {
                                        if let deleteIndex = self.sections[section]?.firstIndex(where: { $0.id == item.id }) {
                                            withAnimation {
                                                _ = self.sections[section]?.remove(at: deleteIndex)
                                            }
                                        }
                                    }
                                
                                VStack {
                                    
                                    Text(item.name)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .font(.body)
                                }
                                .frame(height: 80)
                                .background(Color.purple)
                                .cornerRadius(8)
                                .onTapGesture {
                                    self.onTapItem?(item.id)
                                }
                            }
                            .onDrag {
                                self.draggingItem = item
                                self.draggingSection = section
                                return NSItemProvider(object: item.id as NSString)
                            }
                            .onDrop(of: [.text], delegate: ItemDropDelegate(
                                dropItem: item,
                                dropSection: section,
                                dragItem: $draggingItem,
                                dragSection: $draggingSection,
                                sections: $sections
                            ))
                        }
                    }
                    .padding(.top)
                }
            }
        }
    }
}

struct ItemDropDelegate: DropDelegate {
    let dropItem: Item
    let dropSection: String
    @Binding var dragItem: Item?
    @Binding var dragSection: String?
    @Binding var sections: [String: [Item]]
    
    // Perform when the drop is released
    func performDrop(info: DropInfo) -> Bool {
        
        guard let dragSection = dragSection, let dragItem = dragItem else {
            self.dragItem = nil
            self.dragSection = nil
            return false
        }
        
        guard let dragIndex = self.sections[dragSection]?.firstIndex(where: { $0.id == dragItem.id }),
              let dropIndex = self.sections[dropSection]?.firstIndex(where: { $0.id == dropItem.id }) else {
            self.dragItem = nil
            self.dragSection = nil
            return false
        }
        
        if dragSection == dropSection {
            self.sections[dragSection]?.swapAt(dragIndex, dropIndex)
        } else {
            self.sections[dragSection]?.remove(at: dragIndex)
            self.sections[dropSection]?.insert(dragItem, at: dropIndex)
        }
        
        self.dragItem = nil
        self.dragSection = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        
        guard let dragSection = dragSection, let dragItem = dragItem else { return }
        
        guard let dragIndex = self.sections[dragSection]?.firstIndex(where: { $0.id == dragItem.id }),
              let dropIndex = self.sections[dropSection]?.firstIndex(where: { $0.id == dropItem.id }) else { return }
        
        withAnimation {
            if dragSection == dropSection {
                self.sections[dragSection]?.move(fromOffsets: IndexSet(integer: dragIndex), toOffset: (dropIndex > dragIndex ? (dropIndex + 1) : dropIndex))
            } else {
                self.sections[dragSection]?.remove(at: dragIndex)
                self.sections[dropSection]?.insert(dragItem, at: dropIndex)
                self.dragSection = self.dropSection
            }
        }
    }
}

struct ItemDropSectionDelegate: DropDelegate {
    let dropSection: String
    @Binding var dragItem: Item?
    @Binding var dragSection: String?
    @Binding var sections: [String: [Item]]
    
    func performDrop(info: DropInfo) -> Bool {
        
        guard let dragSection = dragSection, let dragItem = dragItem else {
            self.dragItem = nil
            self.dragSection = nil
            return false
        }
        
        guard let dragIndex = self.sections[dragSection]?.firstIndex(where: { $0.id == dragItem.id }) else {
            self.dragItem = nil
            self.dragSection = nil
            return false
        }
        
        if dragSection != dropSection {
            self.sections[dragSection]?.remove(at: dragIndex)
            self.sections[dropSection]?.insert(dragItem, at: 0)
        }
        
        self.dragItem = nil
        self.dragSection = nil
        return true
    }
}

#Preview {
    DroppableStack(sections: .constant([String : [Item]]()))
}
