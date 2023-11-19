//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Руслан  on 06.11.2023.
//

import UIKit

protocol CollectionViewControllerProtocol: AnyObject & LoadingView {
    var presenter: CollectionPresenterProtocol { get set }
    func updateCollectionView()
    func setupCollection(_ collections: CollectionModel)    
}

final class CollectionViewController: UIViewController & CollectionViewControllerProtocol {
    
    // MARK: Public properties
    var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var presenter: CollectionPresenterProtocol
    
    // MARK: Private properties
    private var authorURL: String = ""
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let coverImage: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let authorTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapUserNameLabel(_:)))
        )
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifier)
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: Init
    init(presenter: CollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
        self.presenter.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            hidesBottomBarWhenPushed = false
        }
    }
    
    // MARK: Public func
    func setupCollection(_ collections: CollectionModel) {
        let author = presenter.getAuthor()
        authorURL = author.website
        authorNameLabel.text = author.name
        
        let urlString = collections.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString!)
        coverImage.kf.indicatorType = .activity
        coverImage.kf.setImage(with: url, placeholder: UIImage(named: "Catalog.nulImage"))
        
        nameLabel.text = collections.name
        descriptionLabel.text = collections.description
        authorTitleLabel.text = "Автор коллекции:"
        heightCollection(of: collections.nfts.count)
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    // MARK: Private func
    private func heightCollection(of nftsCount: Int) {
        let collectionHeight = (
            Constants.cellHeight.rawValue + Constants.lineMargins.rawValue) *
            ceil(CGFloat(nftsCount) /
            Constants.cellCols.rawValue
        )
        collectionView.heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
    }
    
    // MARK: Selectors
    @objc
    private func didTapUserNameLabel(_ sender: Any) {
        guard let urlString = authorURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString)
        else { return }
        let webViewController = WebViewViewController(webSite: url)
        webViewController.modalPresentationStyle = .fullScreen
        present(webViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.getNftsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionCell.identifier,
            for: indexPath
        ) as? CollectionCell else {
            assertionFailure("Failed to dequeue CollectionCell for indexPath: \(indexPath)")
            return UICollectionViewCell()
        }
        
        setupCell(cell, indexPath)

        return cell
    }
    
    private func setupCell(_ cell: CollectionCell, _ indexPath: IndexPath) {
        presenter.getNftsIndex(indexPath.row) { nftsModel in
            switch nftsModel {
            case .success(let nftsModel):
                cell.configureCell(nftsModel)
                print(nftsModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = floor((collectionView.frame.width - Constants.cellMargins.rawValue * (Constants.cellCols.rawValue - 1)) / Constants.cellCols.rawValue)
            return CGSize(width: width, height: Constants.cellHeight.rawValue)
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return Constants.cellMargins.rawValue
        }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.lineMargins.rawValue
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CollectionViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Setup Views/Constraints
private extension CollectionViewController {
    func setupViews() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupScrollView()
        setupActivityIndicator()
        
        scrollView.addSubviews(coverImage, nameLabel, authorTitleLabel, authorNameLabel, descriptionLabel, collectionView)
        
        setupCoverImage()
        setupNameLabel()
        setupAuthorTitleLabel()
        setupAuthorNameLabel()
        setupDescriptionLabel()
        setupCollectionView()
    }
    
    func setupNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .black
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    }
    
    func setupScrollView() {
        view.addSubviews(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func setupActivityIndicator() {
        view.addSubviews(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupCoverImage() {
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: 310),
            coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupNameLabel() {
        scrollView.addSubviews(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideMargins.rawValue)
        ])
    }
    
    func setupAuthorTitleLabel() {
        NSLayoutConstraint.activate([
            authorTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 13),
            authorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideMargins.rawValue)
        ])
    }
    
    func setupAuthorNameLabel() {
        NSLayoutConstraint.activate([
            authorNameLabel.topAnchor.constraint(equalTo: authorTitleLabel.topAnchor),
            authorNameLabel.leadingAnchor.constraint(equalTo: authorTitleLabel.trailingAnchor, constant: 4),
            authorNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideMargins.rawValue)
        ])
    }
    
    func setupDescriptionLabel() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideMargins.rawValue),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideMargins.rawValue)
        ])
    }
    
    func setupCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.sideMargins.rawValue),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.sideMargins.rawValue),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - Constants
private extension CollectionViewController {
    enum Constants: CGFloat {
        case cellMargins = 9
        case lineMargins = 8
        case cellCols = 3
        case cellHeight = 192
        case sideMargins = 16
    }
}