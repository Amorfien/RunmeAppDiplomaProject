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
//        self.navigationItem.title = "Профиль"
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(showMenu))
        navigationItem.rightBarButtonItem = menuButton
//        let newPost = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .done, target: self, action: #selector(newPost))
        let newPost = UIBarButtonItem(title: "➕ Добавить тренировку", style: .done, target: self, action: #selector(newPost))

        navigationItem.leftBarButtonItem = newPost
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

//    @objc private func timeChange(_ sender: UIDatePicker) {
//        print(sender.date)
//    }

    @objc private func newPost() {

        lazy var datePicker: UIDatePicker = {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .time
            datePicker.date = DateFormatter().date(from: "") ?? Date()
//            datePicker.addTarget(self, action: #selector(timeChange), for: UIControl.Event.valueChanged)
//            datePicker.frame.size = CGSize(width: .zero, height: 400)
//            datePicker.frame = CGRect(x: -20, y: 20, width: 170, height: 100)
            datePicker.frame = CGRect(origin: .init(x: -20, y: 0), size: .zero)
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.locale = Locale(identifier: "ru_RU")

            return datePicker
        }()

        let alertController = UIAlertController(title: "\n\n", message: "в\nр\nе\nм\nя\n\n", preferredStyle: .alert)
        alertController.view.addSubview(datePicker)

        let okAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            dateFormatter.locale = .current
            print(timeFormatter.string(from: datePicker.date), " -  \(alertController.textFields!.first!.text!) - \(alertController.textFields!.last!.text!)")

            let author = AuthManager.shared.currentUser?.uid ?? ""
            let date = dateFormatter.string(from: Date())
            let distance = Int(alertController.textFields?.first?.text ?? "") ?? 0
            let text = alertController.textFields?.last?.text ?? ""
            let timeStr = timeFormatter.string(from: datePicker.date)
            let timeComponentsStr = timeStr.components(separatedBy: ":")
            let hours = Int(timeComponentsStr[0]) ?? 0
            let minutes = Int(timeComponentsStr[1]) ?? 0
            let sec = hours * 3600 + minutes * 60
            let post = RunnerPost(author: author, date: date, text: text, distance: distance, time: sec)

            (self?.profileVC as? ProfileViewController)?.viewModel.savePost(post)
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addTextField { textField in
            textField.tag = 0
            textField.placeholder = "Дистанция в метрах"
            textField.keyboardType = .numberPad
            textField.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
            textField.delegate = self
        }

        alertController.addTextField { textField in
            textField.tag = 2
            textField.placeholder = "Описание"
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

}

extension ContainerViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 5 {
            textField.deleteBackward()
        }
    }
}
