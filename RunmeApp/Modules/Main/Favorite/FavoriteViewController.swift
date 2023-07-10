//
//  FavoriteViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class FavoriteViewController: UIViewController {

    private let viewModel: FavoriteViewModel

    private let runnersImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "two")
        image.contentMode = .scaleAspectFit
//        image.conte
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

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
        //        lazy var notifyButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(notifyButtonTap))
        lazy var searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTap))
        //        navigationItem.rightBarButtonItems = [notifyButton, searchButton]
        navigationItem.rightBarButtonItem = searchButton
    }

    private func setupView() {
        view.backgroundColor = Res.PRColors.prLight
        view.addSubview(runnersImageView)

        NSLayoutConstraint.activate([
            runnersImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            runnersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            runnersImageView.widthAnchor.constraint(equalToConstant: 250),
            runnersImageView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }


    // MARK: - ViewModel Binding
    
    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {

            case .initial:
                ()

            }
        }

    }





    //MARK: - Actions
    @objc private func searchButtonTap() {

    }
    @objc private func notifyButtonTap() {

    }
}
