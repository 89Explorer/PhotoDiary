//
//  HomeCell.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/16/25.
//

import UIKit
import SDWebImage

class HomeCell: UICollectionViewCell {
    
    
    // MARK: - Variable
    static let reuseIdentifier: String = "HomeCell"
    
    
    // MARK: - UI Component
    private let shadowContainerView = UIView()
    private let imageView = UIImageView()
    private let dateLabel = UILabel()
    private let optionButton = UIButton()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil 
    }
    
    
    // MARK: - Function
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
        shadowContainerView.layer.shadowRadius = 12
        shadowContainerView.layer.cornerRadius = 12
        shadowContainerView.backgroundColor = .clear
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = .systemFont(ofSize: 32, weight: .bold)
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
    
    func configure(date: Date, imageURL: URL?) {
        let calendar = Calendar.current
        
        // 날짜 포맷: 일(day)과 요일(EEE) 분리
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "en_US_POSIX")
        dayFormatter.dateFormat = "d"
        let dayString = dayFormatter.string(from: date)
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "en_US_POSIX")
        weekdayFormatter.dateFormat = "EEE"
        let weekdayString = weekdayFormatter.string(from: date)
        
        // 스타일 적용
        let fullString = "\(dayString) \(weekdayString)"
        let attributed = NSMutableAttributedString(string: fullString)
        
        // "7" 부분 (더 크게, 굵게)
        if let dayRange = fullString.range(of: dayString) {
            let nsRange = NSRange(dayRange, in: fullString)
            attributed.addAttributes([
                .font: UIFont.systemFont(ofSize: 44, weight: .bold)
            ], range: nsRange)
        }
        
        // "Mon" 부분 (작게, 보통)
        if let weekdayRange = fullString.range(of: weekdayString) {
            let nsRange = NSRange(weekdayRange, in: fullString)
            attributed.addAttributes([
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ], range: nsRange)
        }
        
        dateLabel.attributedText = attributed
        
        // 색상 설정 (공휴일/주말 포함)
        let holidayFormatter = DateFormatter()
        holidayFormatter.locale = Locale(identifier: "ko_KR")
        holidayFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = holidayFormatter.string(from: date)
        
        let holidays: [String] = [
            "2025-01-01", "2025-03-01", "2025-05-05", "2025-06-06",
            "2025-08-15", "2025-10-03", "2025-10-09", "2025-12-25"
        ]
        let isHoliday = holidays.contains(dateString)
        let weekday = calendar.component(.weekday, from: date)
        
        var textColor: UIColor = .label
        if isHoliday || weekday == 1 {
            textColor = .systemRed
        } else if weekday == 7 {
            textColor = .systemBlue
        }
        
        dateLabel.textColor = textColor
        
        imageView.sd_setImage(with: imageURL, placeholderImage: nil, options: [.highPriority])
    }
    
}

