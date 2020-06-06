// FeedFooter.swift
// Created on 2020-06-06
// Distributed under MIT License
// Copyright © 2020 www.codewithshabib.com

import SwiftUI

struct FeedFooterView: View {
    var body: some View {
        VStack {
            Text("Feed Footer")
                .font(.caption)
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment: .leading)
                .padding(.leading)

            Divider()
        }
    }
}

final class FeedCollectionFooterView: UICollectionReusableView {
    override init(frame _: CGRect) {
        super.init(frame: .zero)
        setupView()
        backgroundColor = .red
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let headerView = FeedFooterView()
        let hostingController = UIHostingController(rootView: headerView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hostingController.view)

        hostingController.view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        hostingController.view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        hostingController.view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
