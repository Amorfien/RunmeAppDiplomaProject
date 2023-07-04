//
//  ContainerViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 04.07.2023.
//

import UIKit

final class ContainerViewController: UIViewController {

    private var profileVC: UIViewController
    private var menuVC: UIViewController

    private var menuIsVisible = false

    //MARK: - Init

    init(profileVC: UIViewController, menuVC: UIViewController) {
        self.profileVC = profileVC
        self.menuVC = menuVC
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print(#function, " ContainerViewController 📱")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        setupNavigation()
        configureProfileVC()
        configureMenuVC()

    }

    private func setupNavigation() {
        self.navigationItem.title = "Профиль"
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(showMenu))
        navigationItem.rightBarButtonItem = logoutButton
    }

    func configureProfileVC() {
        view.addSubview(profileVC.view)
        addChild(profileVC)
    }

    func configureMenuVC() {
        view.insertSubview(menuVC.view, at: 0)
        addChild(menuVC)
    }

    @objc private func showMenu() {

        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.profileVC.view.frame.origin.x += self.menuIsVisible ? 152 : -152
        }
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: !menuIsVisible ? "arrow.right.to.line" : "line.3.horizontal")
        menuIsVisible.toggle()

    }


}
