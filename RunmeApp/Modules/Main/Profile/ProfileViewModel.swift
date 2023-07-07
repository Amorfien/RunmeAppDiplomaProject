//
//  ProfileViewModel.swift
//  RunmeApp
//
//  Created by Pavel Grigorev on 23.06.2023.
//

import UIKit

protocol ProfileViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((ProfileViewModel.State) -> Void)? { get set }
    func updateState(viewInput: ProfileViewModel.ViewInput)
}

final class ProfileViewModel: ProfileViewModelProtocol {

    weak var coordinator: ProfileCoordinator?
    
    enum State {
        case initial
        case loading
        case loadedProfile(Runner)
        case loadedImageData(Data)
        case settings(Runner?)
        case error(Error)
    }

    enum ViewInput {
        case showUser
        case saveStatus(String)
        case savePhoto(UIImage)
        case updateUser(Runner)
        case menuSettings
        case logOut
    }

    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    private let userId: String
    var fetchedUser: Runner? = nil

    init(userId: String) {
        self.userId = userId
    }
    deinit {
        print(#function, " ProfileViewModel ⚙️")
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .showUser:
            self.state = .loading
            DatabaseService.shared.getUser(userId: userId) { [weak self] dbResult in
                switch dbResult {
                case .success(let profile):
                    self?.fetchedUser = profile
                    sleep(1)
                    self?.state = .loadedProfile(profile)

                case .failure(_):
                    ()
                }
            }

            FirebaseStorageService.shared.downloadById(id: userId) { [weak self] imgResult in
                switch imgResult {
                case .success(let data):
                    self?.state = .loadedImageData(data)
                case .failure(_):
                    ()
                }
            }
        case .updateUser(var user):
            //тут сравниваются старые результаты с новыми
            user.personalBests.enumerated().forEach { (i, res) in
                let fetchRes = fetchedUser?.personalBests[i] ?? 0
                if res == 0 {
                    user.personalBests[i] = fetchedUser?.personalBests[i] ?? 0
                } else if res > fetchRes && fetchRes > 0 {
                    user.personalBests[i] = fetchedUser?.personalBests[i] ?? 0
                }
            }

            DatabaseService.shared.updateUser(user: user) { saveResult in
                switch saveResult {
                case .success(_):
                    print("User update")
                case .failure(_):
                    print("Save user ERROR")
                }
            }

        case .saveStatus(let status):
            guard var user = fetchedUser else { return }
            user.statusText = status
            //TODO: - заменить на апдейт?
            DatabaseService.shared.setUser(user: user) { uplResult in
                switch uplResult {
                case .success(_):
                    print("Status success")
//                    self.state = .loadedProfile(user)
                case .failure(_):
                    print("Status failed")
                }
            }
        case .savePhoto(let image):
            guard let currentUserId = AuthManager.shared.currentUser?.uid else { return }
            FirebaseStorageService.shared.upload(currentUserId: currentUserId, photo: image) { imgResult in
                switch imgResult {
                case .success(_):
                    print("The avatar has been uploaded")
                case .failure(_):
                    print("Uploading FAIL")
                }
            }
        case .menuSettings:
            coordinator?.showSettings(userSettings: fetchedUser)
//            self.state = .settings(fetchedUser)

        case .logOut:
            AuthManager.shared.signOut()
            coordinator?.logOut()
        }
    }
}
