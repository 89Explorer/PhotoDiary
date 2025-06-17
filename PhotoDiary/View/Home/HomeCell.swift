//
//  HomeCell.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/16/25.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "HomeCell"
    
    private let shadowContainerView = UIView()
    private let imageView = UIImageView()
    private let dateLabel = UILabel()
    private let optionButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupShadow() {
        contentView.addSubview(shadowContainerView)
        shadowContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shadowContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shadowContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        shadowContainerView.layer.shadowColor = UIColor.systemGray.cgColor
        shadowContainerView.layer.shadowOpacity = 0.3
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowContainerView.layer.shadowRadius = 8
        shadowContainerView.layer.cornerRadius = 12
        shadowContainerView.backgroundColor = .clear
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        imageView.image = UIImage(named: "sample")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = .systemFont(ofSize: 32, weight: .bold)
        dateLabel.text = "7, OCT"
        dateLabel.textColor = .label
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        optionButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        optionButton.tintColor = .label
        optionButton.backgroundColor = .systemBackground
        optionButton.layer.cornerRadius = 20
        optionButton.layer.masksToBounds = true
        optionButton.transform = CGAffineTransform(rotationAngle: .pi * 0.5)
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        
        shadowContainerView.addSubview(imageView)
        imageView.addSubview(dateLabel)
        imageView.addSubview(optionButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: shadowContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: shadowContainerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: shadowContainerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: shadowContainerView.bottomAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20),
            dateLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 20),
            
            optionButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20),
            optionButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            optionButton.widthAnchor.constraint(equalToConstant: 40),
            optionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

