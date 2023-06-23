//
//  HomeViewController.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 22.06.2023.
//

import UIKit

final class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen

        self.title = "Home"
        navigationController?.navigationBar.backgroundColor = .brown
    }


}
