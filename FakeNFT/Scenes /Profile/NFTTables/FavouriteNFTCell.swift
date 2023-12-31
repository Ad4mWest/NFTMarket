//  FavouriteNFTCell.swift
//  FakeNFT
//  Created by Adam West on 05.11.2023.

import UIKit
import Kingfisher

final class FavouriteNFTCell: UICollectionViewCell & ReuseIdentifying {
    // MARK: Delegate
    weak var delegate: InterfaceFavouriteNFTCell?
    
    // MARK: Setup UI
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: ImagesAssets.like.rawValue), for: .highlighted)
        button.setImage(UIImage(named: ImagesAssets.like.rawValue), for: .normal)
        button.addTarget(self, action: #selector(checkButtonTapped(sender:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(animateLike(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(stopAnimationOfLike(sender:)), for: .touchUpOutside)
        return button
    }()
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    // MARK: Private Properties
    private var currentNft = Nft()
    private let nameLabel: MyNFTLabel
    private let priceLabel: MyNFTLabel
    private let ratingStar: RatingStackView
    private let animateLikeButton: InterfaceAnimateLikeButton
    
    // MARK: Initialisation
    override init(frame: CGRect) {
        self.ratingStar = RatingStackView()
        self.animateLikeButton = AnimateLikeButton()
        self.nameLabel = MyNFTLabel(labelType: .big, text: nil)
        self.priceLabel = MyNFTLabel(labelType: .middle, text: nil)
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration of cell 
    func configure(with nft: Nft) {
        if let image = nft.images.first {
            nftImageView.kf.indicatorType = .activity
            nftImageView.kf.setImage(with: image)
        }
        let nftPrice = nft.price.formatPrice()
        nameLabel.text = nft.name
        ratingStar.rating = nft.rating
        priceLabel.text = "\(nftPrice) ETH"
        currentNft = nft
    }
    
    // MARK: Selectors
    @objc private func animateLike(sender: UIButton) {
        animateLikeButton.animateLikeButton(sender)
    }
    
    @objc private func stopAnimationOfLike(sender: UIButton) {
        animateLikeButton.stopLikeButton(sender)
    }
    
    @objc private func checkButtonTapped(sender : UIButton) {
        delegate?.removeFromCollectionFavoritesNFT(currentNft)
    }
}

// MARK: - Setup views, constraints
private extension FavouriteNFTCell {
    func setupUI() {
        contentView.addSubviews(nftImageView, likeButton, ratingStar, nameLabel, priceLabel)
                
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 80),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: -6),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 6),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            
            ratingStar.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStar.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            
            priceLabel.topAnchor.constraint(equalTo: ratingStar.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12)
        ])
    }
}

