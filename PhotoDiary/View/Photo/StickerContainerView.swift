//
//  StickerContainerView.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/24/25.
//

import UIKit

class StickerContainerView: UIView {
    
    // MARK: - UI Components
    let imageView: UIImageView
    private let borderLayer = CAShapeLayer()
    private let deleteButton = UIButton(type: .custom)
    
    
    // MARK: - Init
    init(image: UIImage) {
        self.imageView = UIImageView(image: image)
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 150, height: 150)))
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    private func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(imageView)
        imageView.frame = self.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        // 점선 테두리
        borderLayer.strokeColor = UIColor.systemRed.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineDashPattern = [4, 4]
        borderLayer.lineWidth = 2.5
        layer.addSublayer(borderLayer)
        
        // 삭제 버튼
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .systemBackground
        //deleteButton.backgroundColor = .systemBackground
        deleteButton.frame = CGRect(x: self.bounds.width - 20, y: -20, width: 40, height: 40)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        
        self.addSubview(deleteButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.path = UIBezierPath(rect: self.bounds).cgPath
    }
    
    @objc private func deleteTapped() {
        self.removeFromSuperview()
    }
    
    func setSelected(_ isSelected: Bool) {
        borderLayer.isHidden = !isSelected
        deleteButton.isHidden = !isSelected
    }
    
}
