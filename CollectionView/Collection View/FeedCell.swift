// FeedCell.swift
// Created on 2020-06-06
// Distributed under MIT License
// Copyright © 2020 www.codewithshabib.com

import SwiftUI

struct FeedCell: View {
    var item: FeedViewModel

    var body: some View {
        VStack {
            HStack {
                Text(item.name)
                    .font(.body)
                    .frame(maxWidth: .infinity,
                           alignment: .center)
                    .padding(.leading)

                Divider()
                    .padding(.trailing)
            }

            Divider()
                .padding(.leading)
        }
    }
}

final class FeedCollectionCell: UICollectionViewCell {
    var viewModel: FeedViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                fatalError()
            }
            let cell = FeedCell(item: viewModel)
            let hostingController = UIHostingController(rootView: cell)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(hostingController.view)

            hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor)
                .isActive = true
            hostingController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor)
                .isActive = true
            hostingController.view.rightAnchor.constraint(equalTo: contentView.rightAnchor)
                .isActive = true
            hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                .isActive = true
        }
    }

    override init(frame _: CGRect) {
        super.init(frame: .zero)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
