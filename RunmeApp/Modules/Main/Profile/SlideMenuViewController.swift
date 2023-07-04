//
//  SlideMenuViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 03.07.2023.
//

import UIKit

enum SlideMenu: String, CaseIterable {
    case files = "Файлы"
    case bookmarks = "Закладки"
    case favorite = "Избранное"
    case settings = "Настройки"
    case exit = "Выход"
}

protocol SlideMenuDelegate: AnyObject {
    func menuItemTap(_ item: SlideMenu)
}

final class SlideMenuViewController: UIViewController {


    weak var delegate: SlideMenuDelegate?

    private lazy var menuTableView: UITableView = {
        let tableView = UITableView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
//        tableView.separatorInset = .zero
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Res.PRColors.prMedium

        view.addSubview(menuTableView)

        NSLayoutConstraint.activate([
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    deinit {
        print(#function, " SlideMenuViewController 📱")
    }



}


extension SlideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        items.count
        SlideMenu.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "menuCell")
        cell.backgroundColor = .clear
        let selectedView = UIView()
        selectedView.backgroundColor = .tintColor
        cell.selectedBackgroundView = selectedView

        cell.textLabel?.text = SlideMenu.allCases[indexPath.row].rawValue
        cell.textLabel?.textAlignment = .right

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.menuItemTap(SlideMenu.allCases[indexPath.row])
    }

}
