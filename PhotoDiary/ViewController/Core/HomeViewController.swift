//
//  HomeViewController.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/16/25.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    // MARK: - Variable
    private var currentYear: Int = Calendar.current.component(.year, from: Date())
    private var currentMonth: Int = Calendar.current.component(.month, from: Date())
    private var isCalendarVisible = false
    var randomImageURLs: [Int: URL] = [:]
    
    
    // MARK: - UI Component
    private var dateButton: UIButton = UIButton()
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupNavigation()
        setupCollectionView()
        setupDateButton()
        setupIndicator()
        collectionView.isHidden = true
        activityIndicator.startAnimating()
        preloadImagesIfNeeded()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToSelectedDay(Calendar.current.component(.day, from: Date()))
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
        //dateTitle.text = dateText
        dateTitle.text = "투데이"
        
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
        collectionView.backgroundColor = .clear
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
    
    private func setupIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func preloadImagesIfNeeded() {
        let numberOfDays = numberOfDaysIn(month: currentMonth, year: currentYear)
        
        // 1. 이미지 URL 생성
        ImageCacheManager.shared.preloadImages(forDays: numberOfDays)
        
        // 2. SDWebImage로 미리 다운로드 → 캐시에 저장됨
        let urls = (1...numberOfDays).compactMap { ImageCacheManager.shared.url(for: $0) }
        
        SDWebImagePrefetcher.shared.prefetchURLs(urls) { [weak self] finishedCount, skippedCount in
            guard let self = self else { return }
            
            // 3. 프리페칭 완료 시 로딩 멈추고 컬렉션 뷰 갱신
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        }
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
            self.scrollToSelectedDay(1)
            self.collectionView.reloadData()
        }
        present(pickerVC, animated: true)
    }
}


// MARK: - Extension: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysIn(month: currentMonth, year: currentYear)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.reuseIdentifier, for: indexPath) as? HomeCell else {
            return UICollectionViewCell()
        }
        
        let day = indexPath.item + 1
        var components = DateComponents()
        components.year = currentYear
        components.month = currentMonth
        components.day = day
        
        if let date = Calendar.current.date(from: components) {
            
            if let imageURL = ImageCacheManager.shared.url(for: day) {
                cell.configure(date: date, imageURL: imageURL)
            }
        }
        
        return cell
    }
}


// MARK: - Extension: Date -> CollectionView numberOfItemsInSection
extension HomeViewController {
    
    // 날짜에 따른 일 수 계산
    private func numberOfDaysIn(month: Int, year: Int) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 30
    }
    
    // 날짜 선택 후 가운데로 스크롤 함수
    private func scrollToSelectedDay(_ day: Int) {
        let indexPath = IndexPath(item: day - 1, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
