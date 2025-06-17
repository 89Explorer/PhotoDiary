//
//  HomeViewController.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/16/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Variable
    private var currentYear: Int = Calendar.current.component(.year, from: Date())
    private var currentMonth: Int = Calendar.current.component(.month, from: Date())
    private var isCalendarVisible = false
    
    
    // MARK: - UI Component
    private var dateButton: UIButton = UIButton()
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupNavigation()
        setupCollectionView()
        setupDateButton()
        
    }
    
    
    // MARK: - Function
    private func setupNavigation() {
        let dateTitle: UILabel = UILabel()
        //dateTitle.text = "16, Mon"
        dateTitle.font = .systemFont(ofSize: 22, weight: .bold)
        dateTitle.textColor = .systemBlue
        dateTitle.sizeToFit()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "d, MMM"
        let dateText = formatter.string(from: Date())
        dateTitle.text = dateText
        
        let dateButton = UIBarButtonItem(customView: dateTitle)
        navigationItem.leftBarButtonItem = dateButton
    }
}


// MARK: - Extension
extension HomeViewController {
    private func setupCollectionView() {
        let layout = CenterSnapFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        
        let itemWidth = view.bounds.width * 0.8
        // 첫 번째, 마지막 셀도 화면 중앙에 하기 위한 여백 계산
        let inset = (view.bounds.width - itemWidth) / 2
        let itemHeight = view.bounds.height * 0.6
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemRed
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        // 첫 번째, 마지막 셀도 화면 중앙에 하기 위한 여백 적용
        collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionView.contentOffset = CGPoint(x: -inset, y: 0)  // 첫 로딩 때 정렬되도록 보정
        
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setupDateButton() {
        var config = UIButton.Configuration.filled()
        config.title = "\(currentYear), \(currentMonth)"
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .systemBackground
        
        //var titleContainer = AttributeContainer()
        //titleContainer.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        //config.attributedTitle = AttributedString("2025, 06", attributes: titleContainer)
        
        config.image = UIImage(systemName: "chevron.right")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 8)
        config.imagePlacement = .trailing
        config.imagePadding = 4
        dateButton = UIButton(configuration: config)
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.addTarget(self, action: #selector(didTappedMonthButton), for: .touchUpInside)
        
        view.addSubview(dateButton)
        
        NSLayoutConstraint.activate([
            dateButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    private func updateMonthButtonTitle() {
        let title = String(format: "%d, %d", currentYear, currentMonth)
        var config = dateButton.configuration
        config?.title = title
        dateButton.configuration = config
    }
    
    private func toggleDateButtonIcon(isExpanded: Bool) {
        guard var config = dateButton.configuration else { return }
        let iconName = isExpanded ? "chevron.down" : "chevron.right"
        config.image = UIImage(systemName: iconName)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 8)
        dateButton.configuration = config
    }
    
    
    // MARK: - Action
    @objc private func didTappedMonthButton() {
        toggleDateButtonIcon(isExpanded: true)
        let pickerVC = MonthYearPickerViewController(selectedYear: currentYear, selectedMonth: currentMonth)
        
        if let sheet = pickerVC.sheetPresentationController {
            sheet.detents = [
                .custom(resolver: { _ in 300 }) // 원하는 높이
            ]
            sheet.prefersGrabberVisible = false
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 16
        }
        
        pickerVC.onSelect = { [weak self] year, month in
            guard let self = self else { return }
            self.currentYear = year
            self.currentMonth = month
            self.updateMonthButtonTitle()
            self.toggleDateButtonIcon(isExpanded: false)
            self.collectionView.reloadData()
        }

        present(pickerVC, animated: true)
    }
}


// MARK: - Extension: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.reuseIdentifier, for: indexPath)
        return cell
    }
}

