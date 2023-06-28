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
        setupNavigation()
        setupView()
        bindViewModel()

    }

    deinit {
        print(#function, " FavoriteViewController 📱")
    }


    private func setupNavigation() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.backgroundColor = .systemMint
        self.navigationItem.title = "Избранное"
    }

    private func setupView() {
        view.backgroundColor = Res.MyColors.favoriteBackground
    }


    func bindViewModel() {}



}
