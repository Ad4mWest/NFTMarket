//  ProfilePresenter.swift
//  FakeNFT
//  Created by Adam West on 07.11.2023.

import Foundation

protocol InterfaceMyNFTViewController: AnyObject {
    var myNFT: [String] { get set }
    var favoritesNFT: [String] { get set }
}

protocol InterfaceFavouriteNFTViewController: AnyObject {
    var favoritesNFT: [String] { get set }
}

protocol InterfaceProfilePresenter: AnyObject {
    var myNFT: [String] { get set }
    var favoritesNFT: [String] { get set }
    var titleRows: [String] { get set }
    var profile: Profile? { get set }
    var view: InterfaceProfileViewController? { get set }
    func viewDidLoad()
    func setupDelegateMyNFT(viewController: MyNFTViewController)
    func setupDelegateFavouriteNFT(viewController: FavouriteNFTViewController)
    func setupDelegateEditingProfile(viewController: EditingProfileViewController, image: String?, name: String?, description: String?, website: String?)
}
final class ProfilePresenter: InterfaceProfilePresenter {
    // MARK: Public Properties
    var myNFT: [String]
    var favoritesNFT: [String]
    var titleRows: [String] 
    var profile: Profile?
    
    // MARK: Delegates
    weak var delegateToEditing: InterfaceEditingProfileViewController?
    weak var delegateToMyNFT: InterfaceMyNFTViewController?
    weak var delegateToFavouriteNFT: InterfaceFavouriteNFTViewController?
    
    weak var view: InterfaceProfileViewController?
    
    // MARK: Private properties
    private let profileService: ProfileServiceImpl
    
    // MARK: Initialisation
    init() {
        self.myNFT = [String]()
        self.favoritesNFT = [String]()
        self.titleRows = [ ]
        self.profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient(), profileStorage: ProfileStorageImpl())
    }
    
    // MARK: Life cycle
    func viewDidLoad() {
        setupDataProfile { profile in
            guard let profile else { return }
            self.profile = profile
            self.myNFT = profile.nfts
            self.favoritesNFT = profile.likes
            self.titleRows = [
                "Мои NFT (\(self.myNFT.count))",
                "Избранные NFT (\(self.favoritesNFT.count))",
                "О разработчике"
            ]
            self.view?.reloadTable()
            self.view?.updateDataProfile()
        }
    }
    
    // MARK: Setup Network data
    private func setupDataProfile(_ completion: @escaping(Profile?)->()) {
        profileService.loadProfile(id: "1") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                completion(profile)
            case .failure:
                self.view?.showErrorAlert()
            }
        }
    }
    
    // MARK: Setup delegates
    func setupDelegateMyNFT(viewController: MyNFTViewController) {
        delegateToMyNFT = viewController
        delegateToMyNFT?.myNFT = myNFT
        delegateToMyNFT?.favoritesNFT = favoritesNFT
    }
    
    func setupDelegateFavouriteNFT(viewController: FavouriteNFTViewController) {
        delegateToFavouriteNFT = viewController
        delegateToFavouriteNFT?.favoritesNFT = favoritesNFT
    }
    
    func setupDelegateEditingProfile(viewController: EditingProfileViewController, image: String?, name: String?, description: String?, website: String?) {
        delegateToEditing = viewController
        delegateToEditing?.configureDataProfile(image: image, name: name, description: description, website: website)
    }
}