//
//  PhotoDiaryImagePickerViewController.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/16/25.
//

import UIKit
import PhotosUI


class PhotoDiaryImagePickerViewController: UIViewController {
    
    
    // MARK: - Variable
    private let maxSelectionCount: Int = 10
    private var selectedImages: [UIImage] = [] {
        didSet {
            self.editButtonHidden = selectedImages.isEmpty
            DispatchQueue.main.async {
                UIView.transition(with: self.mainImageView,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.mainImageView.image = self.selectedImages.first
                    self.collectionView.reloadData()
                },
                                  completion: nil)
            }
        }
    }
    private var currentIndex: Int = 0 {
        didSet {
            guard currentIndex >= 0, currentIndex < selectedImages.count else {
                print("⚠️ currentIndex out of bounds: \(currentIndex)")
                return
            }
            //print("현재 눌린 셀은: \(currentIndex)")
            DispatchQueue.main.async {
                UIView.transition(with: self.mainImageView,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.mainImageView.image = self.selectedImages[self.currentIndex]
                    self.collectionView.reloadData()
                },
                                  completion: nil)
            }
        }
    }
    
    private var editButtonHidden: Bool = true {
        didSet {
            DispatchQueue.main.async {
                self.editButton.isHidden = self.editButtonHidden
            }
        }
    }
    
    // MARK: - UI Component
    private var mainImageView: UIImageView = UIImageView()
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var nextButton: UIButton = UIButton()
    private var editButton: UIButton = UIButton()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupNavigation()
        checkPhotoLibraryPermission()
        setupUI()
    }
    
    
    // MARK: - Function
    private func setupNavigation() {
        title = "사진 일기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissSelf))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showPhotoPicker))
    }
    
    // 권한 설정
    private func checkPhotoLibraryPermission() {
        MediaPermissionManager.shared.request(.album) { [weak self] granted in
            guard let self else { return }
            if granted {
                self.presentPhotoPicker()
            } else {
                self.showPermissionAlert(message: "앨범 접근 권한이 필요합니다. 설정에서 권한을 승인해주세요")
            }
        }
        
    }
    
    private func showPermissionAlert(message: String) {
        let alert = UIAlertController(title: "권한 필요", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    
    
    // MARK: - Action Method
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc private func showPhotoPicker() {
        print("showPhotoPicker tapped")
        checkPhotoLibraryPermission()
    }
    
    @objc private func didTappedEditButton() {
        let editorVC = PhotoEditViewController(with: selectedImages[currentIndex])
        editorVC.modalPresentationStyle = .fullScreen
        editorVC.delegate = self
        present(editorVC, animated: true)
    }
}


// MARK: - Extension: SetupUI
extension PhotoDiaryImagePickerViewController {
    private func setupUI() {
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.masksToBounds = true
//        mainImageView.layer.shadowColor = UIColor.systemGray.cgColor
//        mainImageView.layer.shadowRadius = 8
//        mainImageView.layer.shadowOpacity = 0.3
//        mainImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        mainImageView.backgroundColor = .systemBackground
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.cornerRadius = 8
        collectionView.clipsToBounds = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        
        nextButton.setTitle("글쓰러 가기", for: .normal)
        nextButton.setTitleColor(.label, for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 8
        nextButton.layer.masksToBounds = true
        
        let imageconf = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let editImage = UIImage(systemName: "wand.and.sparkles.inverse", withConfiguration: imageconf)
        editButton.setImage(editImage, for: .normal)
        editButton.tintColor = .label
        editButton.backgroundColor = .systemBackground
        editButton.layer.cornerRadius = 16
        editButton.layer.masksToBounds = true
        editButton.isHidden = editButtonHidden
        editButton.addTarget(self, action: #selector(didTappedEditButton), for: .touchUpInside)
        
        view.addSubview(mainImageView)
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        //view.addSubview(editButton)
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        //editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            mainImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainImageView.heightAnchor.constraint(equalToConstant: 500),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 12),
            collectionView.heightAnchor.constraint(equalToConstant: 120),
            
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
//            editButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -20),
//            editButton.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -20),
//            editButton.widthAnchor.constraint(equalToConstant: 32),
//            editButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
    }
}


// MARK: - Extension: UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoDiaryImagePickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as? PhotoCell else { return PhotoCell() }
        
        if currentIndex == indexPath.item {
            cell.configure(with: selectedImages[indexPath.item],at: indexPath, isSelected: true)
        } else {
            cell.configure(with: selectedImages[indexPath.item], at: indexPath, isSelected: false)
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentIndex = indexPath.item
        //print("currentIndex: \(currentIndex)")
    }
}


// MARK: - Extenion: PHPickerViewControllerDelegate
extension PhotoDiaryImagePickerViewController: PHPickerViewControllerDelegate {
    
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = maxSelectionCount
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        //selectedImages = []
        
        let group = DispatchGroup()
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, errror in
                defer { group.leave() }
                if let image = reading as? UIImage {
                    self.selectedImages.append(image)
                }
            }
        }
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
            if !self.selectedImages.isEmpty {
                self.currentIndex = 0
            }
        }
        
        //        let itemProviders = results.map { $0.itemProvider }
        //        for item in itemProviders {
        //            if item.canLoadObject(ofClass: UIImage.self) {
        //                item.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
        //                    guard let self, let image = image as? UIImage else { return }
        //                    DispatchQueue.main.async {
        //                        if self.selectedImages.count < self.maxSelectionCount {
        //                            self.selectedImages.append(ImageItem(image: image))
        //                            // TODO: Reload collectionView
        //                        }
        //                    }
        //                }
        //            }
        //        }
    }
}


// MARK: - Extension: PhotoCellDelegate
extension PhotoDiaryImagePickerViewController: PhotoCellDelegate {
    func didTappedDeleteButton(_ cell: PhotoCell, didTapDeleteAt indexPath: IndexPath) {
        selectedImages.remove(at: indexPath.item)
    }
}


// MARK: - Extension: PhotoDiaryImagePickerViewController
extension PhotoDiaryImagePickerViewController: PhotoEditViewControllerDelegate {
    func photoEditViewController(_ controller: PhotoEditViewController, didFinishEditing image: UIImage) {
        // ✅ 편집된 이미지를 받았을 때 처리
        self.mainImageView.image = image
        self.selectedImages[currentIndex] = image
        self.collectionView.reloadItems(at: [IndexPath(item: currentIndex, section: 0)])
    }
}
