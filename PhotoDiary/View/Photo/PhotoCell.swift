//
//  PhotoCell.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/19/25.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "PhotoCell"
    weak var delegate: PhotoCellDelegate?
    private var indexPath: IndexPath?
    
    
    // MARK: - UI Component
    private let imageView = UIImageView()
    private var deleteImageButton: UIButton = UIButton(type: .system)
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowColor = UIColor.systemGray.cgColor
        contentView.layer.cornerRadius = 4
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 8
        
        seupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func seupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        let xmarkImage = UIImage(systemName: "x.circle.fill", withConfiguration: config)
        deleteImageButton.setImage(xmarkImage, for: .normal)
        deleteImageButton.layer.cornerRadius = 10
        deleteImageButton.clipsToBounds = true
        deleteImageButton.backgroundColor = .white
        deleteImageButton.tintColor = .black
        deleteImageButton.addTarget(self, action: #selector(didTappedDeleteImage), for: .touchUpInside)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        deleteImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(deleteImageButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            deleteImageButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            deleteImageButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            deleteImageButton.widthAnchor.constraint(equalToConstant: 20),
            deleteImageButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with image: UIImage, at indexPath: IndexPath, isSelected:Bool) {
        imageView.image = image
        self.indexPath = indexPath
        contentView.layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : nil
        contentView.layer.borderWidth = isSelected ? 3 : 0
    }
    
    
    // MARK: - Action Method
    @objc private func didTappedDeleteImage() {
        guard let indexPath else { return }
        delegate?.didTappedDeleteButton(self, didTapDeleteAt: indexPath)
    }
}


// MARK: - Protocol
protocol PhotoCellDelegate: AnyObject {
    func didTappedDeleteButton(_ cell: PhotoCell, didTapDeleteAt indexPath: IndexPath)
}
