//
//  SlideMenuViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 03.07.2023.
//

import UIKit

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
        view.backgroundColor = Res.PRColors.prRegular

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: -8, height: 0)
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor =  UIColor.tintColor.cgColor

        view.addSubview(menuTableView)

        NSLayoutConstraint.activate([
            menuTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            menuTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuTableView.widthAnchor.constraint(equalToConstant: 180)
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
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        cell.textLabel?.textAlignment = .right

        let item = SlideMenu.allCases[indexPath.row]
        let cellImgView = UIImageView(image: UIImage(systemName: item.ico))
        cell.textLabel?.textColor = UIColor(named: item.color)

        cellImgView.frame = CGRect(x: 12, y: 12, width: 20, height: 20)
        cell.addSubview(cellImgView)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.menuItemTap(SlideMenu.allCases[indexPath.row])
    }

}
