// FeedService.swift
// Created on 2020-06-06
// Copyright © 2020 www.codewithshabib.com

import Combine
import Foundation

struct FeedService {
    // request per page
    private let rpp = 51

    func fetchItems(page: Int) -> AnyPublisher<[Model], Never> {
        Future<[Model], Never> { promise in
            self.fakeAPIRequest(page: page) { items in
                promise(.success(items))
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }

    // fake API call
    private func fakeAPIRequest(page: Int, completion: @escaping ([Model]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if page == 1 {
                var items = [Model]()
                // faking refresh or first page request
                for i in 1 ... self.rpp {
                    let item = Model(name: "Item \(i)")
                    items.append(item)
                }
                completion(items)
            } else {
                var items = [Model]()
                // faking pagination request
                for i in 1 ... self.rpp {
                    let quest = Model(name: "Item \((page - 1) * self.rpp + i)")
                    items.append(quest)
                }
                completion(items)
            }
        }
    }
}
