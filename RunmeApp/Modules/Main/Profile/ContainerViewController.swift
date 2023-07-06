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

    private var menuIsVisible = false {
        didSet {
            menuIsVisible ?
            profileVC.view.addGestureRecognizer(tapProfileGesture) :
            profileVC.view.removeGestureRecognizer(tapProfileGesture)
        }
    }
    private lazy var tapProfileGesture = UITapGestureRecognizer(target: self, action: #selector(showMenu))

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
        view.backgroundColor = .black
        setupNavigation()
        configureProfileVC()
        configureMenuVC()
//        setupGestures()
    }

    private func setupNavigation() {
        self.navigationItem.title = "Профиль"
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(showMenu))
        navigationItem.rightBarButtonItem = logoutButton
    }

    private func configureProfileVC() {
        view.addSubview(profileVC.view)
        addChild(profileVC)
    }

    private func configureMenuVC() {
//        view.insertSubview(menuVC.view, at: 1)
        view.addSubview(menuVC.view)
        menuVC.view.frame.origin.x = UIScreen.main.bounds.width + 20
        addChild(menuVC)
    }

    @objc private func showMenu() {

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.menuVC.view.frame.origin.x += self.menuIsVisible ? 180 : -180
            self.profileVC.view.frame.origin.x += self.menuIsVisible ? 16 : -16
            self.profileVC.view.alpha = self.menuIsVisible ? 1 : 0.8
        }
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: !menuIsVisible ? "arrow.right.to.line" : "line.3.horizontal")
        menuIsVisible.toggle()

    }


}
