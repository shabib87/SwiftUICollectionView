// Interactor.swift
// Created on 2020-06-06
// Distributed under MIT License
// Copyright © 2020 www.codewithshabib.com

import Combine
import Foundation

final class Interactor: ObservableObject {
    @Published var items = [FeedViewModel]()

    var cancellables = Set<AnyCancellable>()

    let loadMoreSubject = PassthroughSubject<Void, Never>()
    let itemSelectionSubject = PassthroughSubject<IndexPath, Never>()
    let pullToRefreshSubject = PassthroughSubject<PullToRefreshCompletion, Never>()

    init(service: FeedService) {
        self.service = service
    }

    func loadMore() {
        currentPage += 1
        fetchQuests()
    }

    @discardableResult func refresh() -> AnyPublisher<Void, Never> {
        currentPage = 1
        fetchQuests(isRefreshing: true)
        return refreshCompletionSubject.eraseToAnyPublisher()
    }

    private let service: FeedService
    private var currentPage = 1
    private let refreshCompletionSubject = PassthroughSubject<Void, Never>()

    private func fetchQuests(isRefreshing: Bool = false) {
        service.fetchItems(page: currentPage)
            .map { items in
                items.map { FeedViewModel(model: $0) }
            }
            .sink {
                if isRefreshing {
                    self.items = $0
                    self.refreshCompletionSubject.send()
                } else {
                    self.items.append(contentsOf: $0)
                }
                print("### Fetched page: \(self.currentPage)")
            }
            .store(in: &cancellables)
    }
}
