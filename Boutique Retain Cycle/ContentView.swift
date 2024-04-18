//
//  ContentView.swift
//  Boutique Retain Cycle
//
//  Created by MBO on 4/18/24.
//

import SwiftUI
import Boutique

struct ListItem: Codable, Identifiable, Equatable {
    let id: String
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

struct Stores {
    static let items = SQLiteStorageEngine(directory:
            .defaultStorageDirectory(appendingPath: "listItem"))!
}

extension Store where Item == ListItem {
    static let listItemStore = Store<ListItem>(storage: Stores.items, cacheIdentifier: \.id)
    
}

let useBoutique = false

@MainActor class ViewModel: ObservableObject {
    
    @Stored(in: .listItemStore) var listItems
    @Published var listItems2: [ListItem] = []
    
    init() {
        print("init viewModel")
    }
    
    func loadItems() async {
        var items: [ListItem] = []
        for id in 0..<50 {
            items.append(ListItem(id: String(id)))
        }
        guard useBoutique else {
            listItems2 = items
            return
        }
        do {
            try await $listItems.insert(items)
        } catch {
            print(error)
        }
    }
    
    deinit {
        print("Deinit ViewModel")
    }
}


struct ContentView: View {
    @StateObject var vm = ViewModel()
    @Binding var state: CurrentView
    var body: some View {
        VStack {
            List {
                ForEach(useBoutique ? vm.listItems : vm.listItems2) { item in
                    Text(item.id)
                }
            }
            Button {
                state = .signIn
            } label: {
                Text("Log out")
            }
        }
        .task {
            await vm.loadItems()
        }
    }
}

#Preview {
    ContentView(state: .constant(.signIn))
}

