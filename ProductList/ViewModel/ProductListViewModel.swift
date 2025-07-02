//
//  ProductListViewModel.swift
//  ProductList
//
//  Created by Pavel Popov on 01.07.2025.
//

import Foundation

// ProductListViewModel.swift
enum SortType {
    case price
    case alphabet
}

protocol ProductListViewModelProtocol {
    var onProductsUpdated: (() -> Void)? { get set }
    var onSortTypeChanged: ((String) -> Void)? { get set }
    var productsCount: Int { get }
    
    func viewDidLoad()
    func product(at index: Int) -> Product?
    func toggleSort()
    func isSortButton(indexPath: IndexPath) -> Bool
}

final class ProductListViewModel: ProductListViewModelProtocol {
    private let productService: ProductServiceProtocol
    private var originalProducts: [Product] = []
    private(set) var products: [Product] = []
    private(set) var currentSortType: SortType = .price
    
    // Callbacks
    var onProductsUpdated: (() -> Void)?
    var onSortTypeChanged: ((String) -> Void)?
    
    init(productService: ProductServiceProtocol) {
        self.productService = productService
    }
    
    var productsCount: Int {
        return products.count + 1 // +1 for sort button
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    private func loadData() {
        productService.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.originalProducts = products
                self?.sortProducts(by: .price)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func product(at index: Int) -> Product? {
        let adjustedIndex = index - 1
        guard adjustedIndex >= 0, adjustedIndex < products.count else { return nil }
        return products[adjustedIndex]
    }
    
    func toggleSort() {
        currentSortType = currentSortType == .price ? .alphabet : .price
        sortProducts(by: currentSortType)
        
        let buttonTitle = currentSortType == .price ? "Сортировать по алфавиту" : "Сортировать по цене"
        onSortTypeChanged?(buttonTitle)
    }
    
    func isSortButton(indexPath: IndexPath) -> Bool {
        return indexPath.row == 0
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
}
