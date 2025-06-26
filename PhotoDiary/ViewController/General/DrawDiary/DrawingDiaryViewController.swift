//
//  DrawingDiaryViewController.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/16/25.
//

import UIKit

class DrawingDiaryViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupNavigation()
    }
    
    
    // MARK: - Function
    private func setupNavigation() {
        title = "그림 일기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissSelf))
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}
