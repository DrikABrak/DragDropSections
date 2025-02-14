# DragDropSections

DragDropSections is an iOS project in **SwiftUI** using a DroppableStack component that allows users to modify a list of items grouped into sections via a simple drag and drop.

You can add, delete but most importantly move items within each section and from one section to another.

## 📸 Preview

![Simulator Screen Recording - iPhone 16 Pro - 2025-02-14 at 16 19 49](https://github.com/user-attachments/assets/0819f486-cc78-42dd-8c37-05c79f34a433)

## 🚀 Features


📌 Smooth movement of items between sections

🔄 Automatically updates the data source

🎨 Customizable to fit your UI

## 🛠 Installation

Simply add the DroppableStack.swift file to your project.

## 📖 Usage

Here is a quick example of how to use the component:

``` swift
@State private var items = [
        "Section 1": [Item(id: "1", name: "Item 1"), Item(id: "2", name: "Item 2"), Item(id: "3", name: "Item 3")],
        "Section 2": [Item(id: "4", name: "Item 4"), Item(id: "5", name: "Item 5"), Item(id: "6", name: "Item 6")],
        "Section 3": [Item(id: "7", name: "Item 7"), Item(id: "8", name: "Item 8"), Item(id: "9", name: "Item 9")]
    ]

struct ContentView: View {
    var body: some View {  
        DroppableStack(
            sections: $items,
            onTapItem: { itemId in },
            addItem: { section in }
        )
    }
}
```

## 📜 License

No license. It's free, just enjoy!
