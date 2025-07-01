//
//  ProductListViewModel.swift
//  ProductList
//
//  Created by Pavel Popov on 01.07.2025.
//

import Foundation

enum SortType {
    case price
    case alphabet
}

final class ProductListViewModel {
    private var originalProducts: [Product] = []
    private(set) var products: [Product] = []
    private(set) var currentSortType: SortType = .price
    
    var onProductsUpdated: (() -> Void)?
    var onSortTypeChanged: ((String) -> Void)?
    
    func configure(with jsonData: Data) {
        do {
            let decoder = JSONDecoder()
            originalProducts = try decoder.decode([Product].self, from: jsonData)
            sortProducts(by: .price)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func toggleSort() {
        currentSortType = currentSortType == .price ? .alphabet : .price
        sortProducts(by: currentSortType)
        
        let buttonTitle = currentSortType == .price ? "Сортировать по алфавиту" : "Сортировать по цене"
        onSortTypeChanged?(buttonTitle)
    }
    
    private func sortProducts(by type: SortType) {
        switch type {
        case .price:
            products = originalProducts.sorted { $0.price < $1.price }
        case .alphabet:
            products = originalProducts.sorted { $0.name < $1.name }
        }
        onProductsUpdated?()
    }
    
    func product(at index: Int) -> Product? {
        guard index >= 0, index < products.count else { return nil }
        return products[index]
    }
}
