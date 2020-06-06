// FeedView.swift
// Created on 2020-06-06
// Copyright © 2020 www.codewithshabib.com

import Combine
import SwiftUI

struct FeedView: UIViewControllerRepresentable {
    private var items: [FeedViewModel]
    private let coordinator: Coordinator

    private let loadMoreSubject: PassthroughSubject<Void, Never>?
    private let itemSelectionSubject: PassthroughSubject<IndexPath, Never>?
    private let pullToRefreshSubject: PassthroughSubject<PullToRefreshCompletion, Never>?

    // MARK: Init

    init(items: [FeedViewModel],
         loadMoreSubject: PassthroughSubject<Void, Never>? = nil,
         itemSelectionSubject: PassthroughSubject<IndexPath, Never>? = nil,
         pullToRefreshSubject: PassthroughSubject<PullToRefreshCompletion, Never>? = nil) {
        self.items = items
        self.loadMoreSubject = loadMoreSubject
        self.itemSelectionSubject = itemSelectionSubject
        self.pullToRefreshSubject = pullToRefreshSubject
    }

    func makeUIViewController(context _: Context)
        -> FeedViewController {
        FeedViewController(
            loadMoreSubject: loadMoreSubject,
            itemSelectionSubject: itemSelectionSubject,
            pullToRefreshSubject: pullToRefreshSubject
        )
    }

    func updateUIViewController(
        _ view: FeedViewController,
        context _: Context
    ) {
        view.updateSnapshot(items: items)
    }
}
