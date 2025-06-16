//
//  MainTabBarController.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/16/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - UI Component
    private let customCenterButton: UIButton = UIButton()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabBar()
        setupCustomCenterButton()
        
    }
    
    // MARK: - Function
    private func setupTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let calendarVC = UINavigationController(rootViewController: CalendarViewController())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house.circle")
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "house.circle.fill")
        homeVC.tabBarItem.title = "Home"
        homeVC.tabBarItem.tag = 0
        
        calendarVC.tabBarItem.image = UIImage(systemName: "calendar.circle")
        calendarVC.tabBarItem.selectedImage = UIImage(systemName: "calendar.circle.fill")
        calendarVC.tabBarItem.title = "Calendar"
        calendarVC.tabBarItem.tag = 1
        
        self.setViewControllers([homeVC, calendarVC], animated: true)
    }
    
    private func setupCustomCenterButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        customCenterButton.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: imageConfig), for: .normal)
        customCenterButton.tintColor = .systemBlue
        customCenterButton.backgroundColor = .systemBackground
        customCenterButton.layer.cornerRadius = 32
        customCenterButton.layer.shadowColor = UIColor.black.cgColor
        customCenterButton.layer.shadowOpacity = 0.1
        customCenterButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        customCenterButton.layer.shadowRadius = 4
        
        customCenterButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        
        view.addSubview(customCenterButton)
        customCenterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customCenterButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            customCenterButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor),
            customCenterButton.widthAnchor.constraint(equalToConstant: 64),
            customCenterButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    
    // MARK: - Action Method
    @objc private func centerButtonTapped() {
        //let sheetVC = DiarySheetViewController()
        let sheetVC = UINavigationController(rootViewController: DiarySheetViewController())
        sheetVC.modalPresentationStyle = .pageSheet
        
        if let sheet = sheetVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                200.0
            }, )]
            sheet.prefersGrabberVisible = true
        }
        present(sheetVC, animated: true)
    }
}

