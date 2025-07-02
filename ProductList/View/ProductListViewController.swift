//
//  ViewController.swift
//  ProductList
//
//  Created by Pavel Popov on 01.07.2025.
//

import UIKit

// ProductListViewController.swift
final class ProductListViewController: UIViewController {
    private var viewModel: ProductListViewModelProtocol
    private let coordinator: ProductListCoordinatorProtocol
    private let tableView = UITableView()
    
    init(viewModel: ProductListViewModelProtocol, coordinator: ProductListCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "Список товаров"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseIdentifier)
        tableView.register(SortButtonCell.self, forCellReuseIdentifier: SortButtonCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onProductsUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onSortTypeChanged = { [weak self] title in
            if let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SortButtonCell {
                cell.configure(title: title)
            }
        }
    }
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.productsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isSortButton(indexPath: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: SortButtonCell.reuseIdentifier, for: indexPath) as! SortButtonCell
            cell.configure(title: "Сортировать по алфавиту")
            cell.onButtonTapped = { [weak self] in
                self?.viewModel.toggleSort()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as! ProductCell
            if let product = viewModel.product(at: indexPath.row) {
                cell.configure(with: product)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard !viewModel.isSortButton(indexPath: indexPath),
              let product = viewModel.product(at: indexPath.row) else { return }
        
        coordinator.showProductDetail(product)
    }
}
