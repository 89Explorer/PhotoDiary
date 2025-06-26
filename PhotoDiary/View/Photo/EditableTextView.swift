//
//  EditableTextView.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/26/25.
//

import UIKit

class EditableTextView: UIView {
    
    
    // MARK: - Variable
    var onDelete: (() -> Void)?
    var onSelect: (() -> Void)?
    
    
    // MARK: - UI Component
    private let textView: UITextView = UITextView()
    private let deleteButton: EnlargedHitAreaButton = EnlargedHitAreaButton(type: .custom)
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        deleteButton.frame = CGRect(x: textView.frame.maxX - 10, y: -10, width: 30, height: 30)
    }
    
    
    // MARK: - Function
    private func setupUI() {
       
        textView.backgroundColor = .clear
        textView.textColor = .label
        textView.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        textView.textAlignment = .left
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1
        textView.delegate = self
        textView.isScrollEnabled = false
        addSubview(textView)
        
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.isUserInteractionEnabled = true
        deleteButton.hitAreaInset = UIEdgeInsets(top: -30, left: -30, bottom: -30, right: -30)
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        addSubview(deleteButton)
        
        // 팬 제스처
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
        
        // 탭 제스처 (선택 가능하게)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        let translation = gesture.translation(in: superview)
        center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
        gesture.setTranslation(.zero, in: superview)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        setSelected(true)
        onSelect?()
        textView.becomeFirstResponder()
    }
    
    @objc private func deleteTapped() {
        onDelete?()
        print("삭제눌림")
        removeFromSuperview()
    }
    
    func setSelected(_ selected: Bool) {
        textView.layer.borderColor = selected ? UIColor.systemBlue.cgColor : UIColor.clear.cgColor
        deleteButton.isHidden = !selected
    }
    
    func resignTextView() {
        textView.resignFirstResponder()
        setSelected(false)
    }
    
    func getImageSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


// MARK: - Extension
extension EditableTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        let maxHeight: CGFloat = 200
        if estimatedSize.height <= maxHeight {
            textView.isScrollEnabled = false
            textView.frame.size.height = estimatedSize.height
            self.frame.size.height = estimatedSize.height
        } else {
            textView.isScrollEnabled = true
        }
        
        deleteButton.frame.origin.y = -10
        deleteButton.frame.origin.x = textView.frame.maxX - 10
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        setSelected(false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setSelected(true)
    }
}
