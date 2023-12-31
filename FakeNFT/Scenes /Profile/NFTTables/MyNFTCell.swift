//  MyNFTCell.swift
//  FakeNFT
//  Created by Adam West on 04.11.2023.

import UIKit
import Kingfisher

final class MyNFTCell: UITableViewCell & ReuseIdentifying {
    // MARK: Delegate
    weak var delegate: InterfaceMyNFTCell?
    
    // MARK: Public properties
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: ImagesAssets.noLike.rawValue), for: .normal)
        button.addTarget(self, action: #selector(animateLike(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(stopAnimationOfLike(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(stopAnimationOfLike(sender:)), for: .touchUpOutside)
        return button
    }()
    
    // MARK: Private properties
    private var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private var currentNft: Nft
    private var nameLabel: MyNFTLabel
    private var ratingStar: RatingStackView
    private var authorLabel: MyNFTLabel
    private var priceLabel: MyNFTLabel
    
    private let fromAuthorLabel: MyNFTLabel
    private let namePriceLabel: MyNFTLabel
    private let animateLikeButton: InterfaceAnimateLikeButton
    
    // MARK: Initialisation
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.currentNft = Nft()
        self.nameLabel = MyNFTLabel(labelType: .big, text: nil)
        self.ratingStar = RatingStackView()
        self.authorLabel = MyNFTLabel(labelType: .little, text: nil)
        self.priceLabel = MyNFTLabel(labelType: .big, text: nil)
        self.fromAuthorLabel = MyNFTLabel(labelType: .middle, text: "от")
        self.namePriceLabel = MyNFTLabel(labelType: .little, text: "Цена")
        self.animateLikeButton = AnimateLikeButton()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    func configure(with nft: Nft, user: User) {
        if let image = nft.images.first {
            nftImageView.kf.indicatorType = .activity
            nftImageView.kf.setImage(with: image)
        }
        let nftPrice = nft.price.formatPrice()
        nameLabel.text = nft.name
        ratingStar.rating = nft.rating
        authorLabel.text = user.name
        priceLabel.text = "\(nftPrice) ETH"
        currentNft = nft
        guard let like = nft.like else { return }
        like ? likeButtonImage() : noLikeButtonImage()
    }
    
    private func changeLike(sender: UIButton) {
        if sender.image(for: .normal) == UIImage(named: ImagesAssets.like.rawValue) {
            noLikeButtonImage()
            delegate?.isLikedNft(id: currentNft.id, isLiked: false)
            delegate?.addLikeNftToFavourite(currentNft, isLiked: false)
        } else {
            likeButtonImage()
            delegate?.isLikedNft(id: currentNft.id, isLiked: true)
            delegate?.addLikeNftToFavourite(currentNft, isLiked: true)
        }
    }
    
    private func likeButtonImage() {
        likeButton.setImage(UIImage(named: ImagesAssets.like.rawValue), for: .normal)
        likeButton.setImage(UIImage(named: ImagesAssets.noLike.rawValue), for: .highlighted)
    }
    
    private func noLikeButtonImage() {
        likeButton.setImage(UIImage(named: ImagesAssets.noLike.rawValue), for: .normal)
        likeButton.setImage(UIImage(named: ImagesAssets.like.rawValue), for: .highlighted)
    }
    
    // MARK: Selectors
    @objc private func animateLike(sender: UIButton) {
        animateLikeButton.animateLikeButton(sender)
        changeLike(sender: sender)
    }
    
    @objc private func stopAnimationOfLike(sender: UIButton) {
        animateLikeButton.stopLikeButton(sender)
    }
}

// MARK: - Setup views, constraints
private extension MyNFTCell {
    func setupUI() {
        contentView.addSubviews(nftImageView, likeButton, ratingStar,
                                nameLabel, fromAuthorLabel, authorLabel,
                                namePriceLabel, priceLabel)
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 39),
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            ratingStar.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStar.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),

            fromAuthorLabel.topAnchor.constraint(equalTo: ratingStar.bottomAnchor, constant: 4),
            fromAuthorLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            fromAuthorLabel.widthAnchor.constraint(equalToConstant: 16),
            
            authorLabel.topAnchor.constraint(equalTo: ratingStar.bottomAnchor, constant: 6),
            authorLabel.leadingAnchor.constraint(equalTo: fromAuthorLabel.trailingAnchor, constant: 4),
            
            namePriceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 46),
            namePriceLabel.leadingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: namePriceLabel.bottomAnchor, constant: 2),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: ratingStar.trailingAnchor, constant: 51)
            
        ])
    }
}
