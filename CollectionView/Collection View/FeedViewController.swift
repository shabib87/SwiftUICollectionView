// FeedViewController.swift
// Created on 2020-06-06
// Distributed under MIT License
// Copyright © 2020 www.codewithshabib.com

import Combine
import UIKit

typealias PullToRefreshCompletion = () -> Void

final class FeedViewController: UIViewController {
    init(loadMoreSubject: PassthroughSubject<Void, Never>? = nil,
         itemSelectionSubject: PassthroughSubject<IndexPath, Never>? = nil,
         pullToRefreshSubject: PassthroughSubject<PullToRefreshCompletion, Never>? = nil,
         prefetchLimit: Int) {
        self.prefetchLimit = prefetchLimit
        self.loadMoreSubject = loadMoreSubject
        self.itemSelectionSubject = itemSelectionSubject
        self.pullToRefreshSubject = pullToRefreshSubject
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateSnapshot(items: [FeedViewModel]) {
        isPaginating = false
        self.items = items
        var snapshot = NSDiffableDataSourceSnapshot<Section, FeedViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func willTransition(
        to newCollection: UITraitCollection,
        with _: UIViewControllerTransitionCoordinator
    ) {
        collectionView.refreshControl?.tintColor = newCollection
            .userInterfaceStyle == .dark ? .white : .black
    }

    private func setupView() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }

    private let prefetchLimit: Int
    private var items = [FeedViewModel]()
    private var isPaginating = false

    private let loadMoreSubject: PassthroughSubject<Void, Never>?
    private let itemSelectionSubject: PassthroughSubject<IndexPath, Never>?
    private let pullToRefreshSubject: PassthroughSubject<PullToRefreshCompletion, Never>?

    private enum Section {
        case main
    }

    private lazy var layout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
        )
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom
        )
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        // pagination
        section.visibleItemsInvalidationHandler = {
            [weak self] visibleItems, _, _ in
            guard let self = self,
                let row = visibleItems.last?.indexPath.row else { return }
            // sending prefetch subscription notice for pagination
            if self.items.count - self.prefetchLimit > 0,
                row >= self.items.count - self.prefetchLimit {
                guard !self.isPaginating else { return }
                self.isPaginating = true
                self.loadMoreSubject?.send()
            }
        }

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FeedCollectionCell.self,
                                forCellWithReuseIdentifier: "FeedCollectionCell")
        collectionView.register(
            FeedCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "FeedCollectionHeaderView"
        )

        collectionView.register(
            FeedCollectionFooterView.self,
            forSupplementaryViewOfKind:
            UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "FeedCollectionFooterView"
        )

        collectionView.delegate = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(
            self,
            action: #selector(pullToRefreshAction),
            for: .valueChanged
        )

        collectionView.refreshControl?.tintColor = traitCollection
            .userInterfaceStyle == .dark ? .white : .black

        return collectionView
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, FeedViewModel> = {
        let dataSource: UICollectionViewDiffableDataSource<Section, FeedViewModel> =
            UICollectionViewDiffableDataSource(
                collectionView: collectionView
            ) { [weak self] collectionView, indexPath, viewModel in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "FeedCollectionCell",
                    for: indexPath
                ) as? FeedCollectionCell
                else { fatalError("Cannot create feed cell") }

                cell.viewModel = viewModel

                return cell
            }

        dataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView,
             kind: String,
             indexPath: IndexPath) -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "FeedCollectionHeaderView",
                    for: indexPath
                ) as? FeedCollectionHeaderView else {
                    fatalError("Cannot create feed header")
                }

                return headerView
            } else {
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "FeedCollectionFooterView",
                    for: indexPath
                ) as? FeedCollectionFooterView else {
                    fatalError("Cannot create feed footer")
                }

                return footerView
            }
        }

        return dataSource
    }()
}

extension FeedViewController {
    @objc private func pullToRefreshAction() {
        pullToRefreshSubject?.send {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemSelectionSubject?.send(indexPath)
    }
}
