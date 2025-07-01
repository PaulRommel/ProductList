//
//  ViewController.swift
//  ProductList
//
//  Created by Pavel Popov on 01.07.2025.
//

import UIKit

final class ProductListViewController: UIViewController {
    private let viewModel: ProductListViewModel
    private let tableView = UITableView()
    
    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        loadData()
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
    
    private func loadData() {
        let json = """
        [
            {
                "id": "tovar1",
                "name": "Товар 1",
                "description": "Это какой-то очень чудесный товар для того, чтобы вы его купили",
                "price": 100
            },
            {
                "id": "car",
                "name": "Машинка с названием, которое скорее всего не влезет в одну строку на очень маленьком экране iPhone",
                "description": "Зато описание у этой машинки очень даже короткое",
                "price": 10000.23
            },
            {
                "id": "flower",
                "name": "Букет цветов",
                "description": "В нем и гвоздики, и герани, и даже чуть цветов акации. Пахнет просто замечательно! И долго радует глаз...",
                "price": 77.24
            },
            {
                "id": "eda",
                "name": "Набор на ужин",
                "description": "Колбаса и немного хлеба. Возможно, если очень повезет, будет еще и масло. Обязательно будет и черный чай с сахаром из стакана в подстаканнике (но его вы купите сами).",
                "price": 77.24
            }
        ]
        """
        
        if let jsonData = json.data(using: .utf8) {
            viewModel.configure(with: jsonData)
        }
    }

    private func showProductDetail(_ product: Product) {
        DispatchQueue.main.async {
            let popup = ProductDetailPopupView()
            popup.configure(with: product)
            
            if let window = UIApplication.shared.currentKeyWindow {
                popup.show(in: window)
            } else {
                popup.show(in: self.view)
            }
        }
    }
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count + 1 // +1 for sort button
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SortButtonCell.reuseIdentifier, for: indexPath) as! SortButtonCell
            cell.configure(title: "Сортировать по алфавиту")
            cell.onButtonTapped = { [weak self] in
                self?.viewModel.toggleSort()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as! ProductCell
            if let product = viewModel.product(at: indexPath.row - 1) {
                cell.configure(with: product)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            return
        }
        
        if let product = viewModel.product(at: indexPath.row - 1) {
            showProductDetail(product)
        }
    }
}
