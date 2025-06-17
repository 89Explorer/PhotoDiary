//
//  DiarySheetViewController.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/16/25.
//

import UIKit

class DiarySheetViewController: UIViewController {
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupButtons()
    }
    
    
    // MARK: - Function
    private func setupButtons() {
        let photoButton = makeButton(title: "📷 사진 일기", action: #selector(photoDiaryTapped))
        let drawingButton = makeButton(title: "🎨 그림 일기", action: #selector(drawingDiaryTapped))
        let cancelButton = makeButton(title: "취소", action: #selector(cancelTapped), color: .systemRed)
        
        let stackView = UIStackView(arrangedSubviews: [photoButton, drawingButton, cancelButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
    }
    
    
    private func makeButton(title: String, action: Selector, color: UIColor = .systemBlue) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1.0
        button.layer.backgroundColor = UIColor.systemBackground.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }
    
    @objc private func photoDiaryTapped() {
        dismiss(animated: true) {
            let photoVC = PhotoDiaryViewController()
            let nav = UINavigationController(rootViewController: photoVC)
            nav.modalPresentationStyle = .fullScreen
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootVC = window.rootViewController {
                rootVC.present(nav, animated: true) 
            }
        }
    }
    
    @objc private func drawingDiaryTapped() {
        dismiss(animated: true) {
            let drawingVC = DrawingDiaryViewController()
            let nav = UINavigationController(rootViewController: drawingVC)
            nav.modalPresentationStyle = .fullScreen
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootVC = window.rootViewController {
                rootVC.present(nav, animated: true)
            }
        }
    }
    
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
}
