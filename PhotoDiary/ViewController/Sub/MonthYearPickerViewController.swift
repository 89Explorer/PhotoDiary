//
//  MonthYearPickerViewController.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/17/25.
//

import UIKit

final class MonthYearPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var onSelect: ((Int, Int) -> Void)?

    private let months = Array(1...12)
    private let years = Array(2000...2100)
    
    private var selectedMonth: Int
    private var selectedYear: Int
    
    private let pickerView = UIPickerView()

    init(selectedYear: Int, selectedMonth: Int) {
        self.selectedYear = selectedYear
        self.selectedMonth = selectedMonth
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)

        // 버튼 추가
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("선택", for: .normal)
        confirmButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)

        // Layout
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            pickerView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -20),

            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        pickerView.selectRow(years.firstIndex(of: selectedYear) ?? 0, inComponent: 0, animated: false)
        pickerView.selectRow(months.firstIndex(of: selectedMonth) ?? 0, inComponent: 1, animated: false)
        
    }

    @objc private func confirmTapped() {
        onSelect?(selectedYear, selectedMonth)
        dismiss(animated: true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? years.count : months.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(years[row])년" : "\(months[row])월"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedYear = years[row]
        } else {
            selectedMonth = months[row]
        }
    }
}
