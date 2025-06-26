//
//  PhotoEditFunctionCell.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/20/25.
//

import UIKit

class PhotoEditFunctionCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "PhotoEditFunctionCell"
    
    
    // MARK: - UI Component
    private var containerView: UIView = UIView()
    private var editButton: UIButton = UIButton(type: .system)
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupUI() {
        containerView.layer.shadowColor = UIColor.systemGray.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 12
        containerView.layer.cornerRadius = 40
        containerView.backgroundColor = .systemBackground
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(systemName: String, title: String) {
        editButton.removeFromSuperview()
        
        editButton = makeCustomButton(systemName: systemName, title: title)
        
        containerView.addSubview(editButton)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            editButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            editButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            editButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4)
        ])
    }
    
    func makeCustomButton(systemName: String, title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: systemName)
        config.title = title
        config.imagePlacement = .top
        config.imagePadding = 4
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .label // 텍스트 및 이미지 색상

        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 36
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false 
        return button
    }
}


