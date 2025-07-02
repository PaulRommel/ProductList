//
//  ProductListCoordinator.swift
//  ProductList
//
//  Created by Pavel Popov on 01.07.2025.
//

import UIKit

// ProductListCoordinator.swift
protocol ProductListCoordinatorProtocol {
    func showProductDetail(_ product: Product)
}

final class ProductListCoordinator: ProductListCoordinatorProtocol {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showProductDetail(_ product: Product) {
        let presenter = ProductDetailPresenter(product: product)
        let popup = ProductDetailPopupView(presenter: presenter)
        
        if let window = UIApplication.currentKeyWindow {
            popup.show(in: window)
        } else if let view = navigationController?.view {
            popup.show(in: view)
        }
    }
}
