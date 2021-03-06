// FeedView.swift
// Created on 2020-06-06
// Distributed under MIT License
// Copyright © 2020 www.codewithshabib.com

import Combine
import SwiftUI

struct FeedView: UIViewControllerRepresentable {
    private var items: [FeedViewModel]

    private let loadMoreSubject: PassthroughSubject<Void, Never>?
    private let itemSelectionSubject: PassthroughSubject<IndexPath, Never>?
    private let pullToRefreshSubject: PassthroughSubject<PullToRefreshCompletion, Never>?
    private let prefetchLimit: Int

    // MARK: Init

    init(items: [FeedViewModel],
         loadMoreSubject: PassthroughSubject<Void, Never>? = nil,
         itemSelectionSubject: PassthroughSubject<IndexPath, Never>? = nil,
         pullToRefreshSubject: PassthroughSubject<PullToRefreshCompletion, Never>? = nil,
         prefetchLimit: Int = 10) {
        self.items = items
        self.loadMoreSubject = loadMoreSubject
        self.itemSelectionSubject = itemSelectionSubject
        self.pullToRefreshSubject = pullToRefreshSubject
        self.prefetchLimit = prefetchLimit
    }

    func makeUIViewController(context _: Context)
        -> FeedViewController {
        FeedViewController(
            loadMoreSubject: loadMoreSubject,
            itemSelectionSubject: itemSelectionSubject,
            pullToRefreshSubject: pullToRefreshSubject,
            prefetchLimit: prefetchLimit
        )
    }

    func updateUIViewController(
        _ view: FeedViewController,
        context _: Context
    ) {
        view.updateSnapshot(items: items)
    }
}
