//
//  ProductDetailPopupView.swift
//  ProductList
//
//  Created by Pavel Popov on 01.07.2025.
//

import UIKit

// ProductDetailPopupView.swift
protocol ProductDetailPresenterProtocol {
    var productName: String { get }
    var productDescription: String { get }
    var formattedPrice: NSAttributedString { get }
}

final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    private let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    var productName: String { product.name }
    var productDescription: String { product.description }
    
    var formattedPrice: NSAttributedString {
        let priceString = NSMutableAttributedString(
            string: product.formattedPrice,
            attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        )
        priceString.append(NSAttributedString(
            string: " ₽",
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        ))
        return priceString
    }
}

final class ProductDetailPopupView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let presenter: ProductDetailPresenterProtocol
    
    init(presenter: ProductDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        alpha = 0
        
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textAlignment = .center
        
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .center
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .gray
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(closeButton)
        addSubview(containerView)
    }
    
    private func configureViews() {
        nameLabel.text = presenter.productName
        descriptionLabel.text = presenter.productDescription
        priceLabel.attributedText = presenter.formattedPrice
    }
    
    private func setupConstraints() {
        [containerView, nameLabel, priceLabel, descriptionLabel, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.8),
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    func show(in view: UIView) {
        DispatchQueue.main.async {
            self.frame = view.bounds
            view.addSubview(self)
            
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.containerView.alpha = 0
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.alpha = 1
                self.containerView.transform = .identity
                self.containerView.alpha = 1
            })
        }
    }
    
    @objc private func closeTapped() {
        hide()
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
