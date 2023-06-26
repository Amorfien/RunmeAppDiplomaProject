//
//  FavoriteViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class FavoriteViewController: UIViewController {

    private let viewModel: FavoriteViewModel

    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange

        self.navigationItem.title = "Favorite"
        navigationController?.navigationBar.backgroundColor = .systemMint
    }

    deinit {
        print(#function, " FavoriteViewController 📱")
    }



}
