//
//  ProductCell.swift
//  ProductList
//
//  Created by Pavel Popov on 01.07.2025.
//

import UIKit

final class ProductCell: UITableViewCell {
    static let reuseIdentifier = "ProductCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        
        let priceString = NSMutableAttributedString(string: product.formattedPrice, attributes: [
            .foregroundColor: UIColor.black
        ])
        
        let rubleSign = NSAttributedString(string: " ₽", attributes: [
            .foregroundColor: UIColor.gray
        ])
        
        priceString.append(rubleSign)
        priceLabel.attributedText = priceString
    }
}

final class SortButtonCell: UITableViewCell {
    static let reuseIdentifier = "SortButtonCell"
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    var onButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func configure(title: String) {
        button.setTitle(title, for: .normal)
    }
    
    @objc private func buttonTapped() {
        onButtonTapped?()
    }
}
