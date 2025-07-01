//
//  ProductDetailPopupView.swift
//  ProductList
//
//  Created by Pavel Popov on 01.07.2025.
//

import UIKit

final class ProductDetailPopupView: UIView {
    // Контейнер
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    // Основные элементы
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Настройка фона
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        alpha = 0
        
        // Настройка меток
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textAlignment = .center
        
        priceLabel.numberOfLines = 1
        priceLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        priceLabel.textAlignment = .center
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        
        // Настройка кнопки закрытия
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .gray
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        // Добавление подвидом
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(closeButton)
        addSubview(containerView)
    }
    
    private func setupConstraints() {
        // Отключаем autoresizing mask
        [containerView, nameLabel, priceLabel, descriptionLabel, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Контейнер
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.8),
            
            // Кнопка закрытия
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            
            // Название
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Цена
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Описание
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        descriptionLabel.text = product.description
        
        let priceString = NSMutableAttributedString(
            string: product.formattedPrice,
            attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        )
        priceString.append(NSAttributedString(
            string: " ₽",
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        ))
        priceLabel.attributedText = priceString
    }
    
    func show(in view: UIView) {
        // Убедимся, что выполняется на главном потоке
        DispatchQueue.main.async {
            // Установим frame и добавим на view
            self.frame = view.bounds
            view.addSubview(self)
            
            // Начальное состояние для анимации
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.containerView.alpha = 0
            
            // Анимация появления
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
