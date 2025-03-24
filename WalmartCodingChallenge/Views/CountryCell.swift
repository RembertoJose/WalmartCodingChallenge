//
//  CountryCell.swift
//  WalmartCodingChallenge
//
//  Created by Remberto Nunez on 3/21/25.
//

import UIKit

class CountryCell: UITableViewCell {
    private let nameRegionLabel = UILabel()
    private let codeLabel = UILabel()
    private let capitalLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        nameRegionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        nameRegionLabel.adjustsFontForContentSizeCategory = true
        nameRegionLabel.lineBreakMode = .byWordWrapping
        nameRegionLabel.numberOfLines = 0
        nameRegionLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        codeLabel.font = UIFont.preferredFont(forTextStyle: .body)
        codeLabel.textAlignment = .right
        codeLabel.adjustsFontForContentSizeCategory = true
        codeLabel.setContentHuggingPriority(.required, for: .horizontal)

        capitalLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        capitalLabel.adjustsFontForContentSizeCategory = true

        let buttomStack = UIStackView(arrangedSubviews: [capitalLabel, codeLabel])
        buttomStack.axis = .horizontal
        buttomStack.distribution = .fill

        let mainStack = UIStackView(arrangedSubviews: [nameRegionLabel, buttomStack])
        mainStack.axis = .vertical
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with country: CountryModel) {
        nameRegionLabel.text = "\(country.displayName), \(country.displayRegion)"
        codeLabel.text = country.displayCode
        capitalLabel.text = country.displayCapital
    }
}
