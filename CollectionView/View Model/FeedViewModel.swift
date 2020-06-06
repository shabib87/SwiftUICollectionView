// FeedViewModel.swift
// Created on 2020-06-06
// Copyright © 2020 www.codewithshabib.com

import Foundation

struct FeedViewModel: Identifiable {
    let id = UUID()
    private let model: Model

    init(model: Model) {
        self.model = model
    }

    var name: String {
        model.name
    }
}

extension FeedViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: FeedViewModel,
                    rhs: FeedViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
