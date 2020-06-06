// ContentView.swift
// Created on 2020-06-06
// Distributed under MIT License
// Copyright © 2020 www.codewithshabib.com

import Combine
import SwiftUI

struct ContentView: View {
    @ObservedObject private(set) var interactor: Interactor

    @State private var shouldShowSelection: Bool = false
    @State private var selectedItemName: String = "" {
        didSet {
            shouldShowSelection = true
        }
    }

    var body: some View {
        NavigationView {
            FeedView(items: interactor.items,
                     loadMoreSubject: interactor.loadMoreSubject,
                     itemSelectionSubject: interactor.itemSelectionSubject,
                     pullToRefreshSubject: interactor.pullToRefreshSubject)
                .onReceive(interactor.loadMoreSubject, perform: {
                    self.interactor.loadMore()
                })
                .onReceive(interactor.itemSelectionSubject, perform: {
                    self.selectedItemName = self.interactor.items[$0.row].name
                })
                .onReceive(interactor.pullToRefreshSubject, perform: { completion in
                    self.interactor.refresh().sink {
                        completion()
                    }
                    .store(in: &self.interactor.cancellables)
                })
                .onAppear {
                    self.interactor.refresh()
                }
                .navigationBarTitle("SwiftUI Collection View",
                                    displayMode: .inline)
                .alert(isPresented: $shouldShowSelection) {
                    Alert(title: Text(selectedItemName))
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView(
                interactor: Interactor(
                    service: FeedService()
                )
            )
        }
    }

#endif
