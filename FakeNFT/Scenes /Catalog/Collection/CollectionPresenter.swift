//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Руслан  on 07.11.2023.
//

import Foundation

struct ProfileModel: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    var likes: [String]
    let id: String
}

protocol CollectionPresenterProtocol {
    var view: CollectionViewControllerProtocol? { get set }
    var profile: ProfileModel? { get set }
    func viewDidLoad()
    func loadProfile()
}

final class CollectionPresenter: CollectionPresenterProtocol {
    
    weak var view: CollectionViewControllerProtocol?
    
    var profile: ProfileModel?
    
    var isCollectionLoadError = false
    
    private let networkClient: NetworkClient
    
    private let loadGroup = DispatchGroup()
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func viewDidLoad() {
        loadProfile()
    }
    
    func loadProfile() {
        //self.loadGroup.enter()
        DispatchQueue.global().async {
            self.networkClient.send(request: GetProfileRequest(),
                                    type: ProfileModel.self,
                                    onResponse: {result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        self.profile = profile
                        self.view?.updateProfileData()
                    case .failure(_):
                        self.isCollectionLoadError = true
                    }
                    //self.loadGroup.leave()
                }
            })
        }
    }
}

