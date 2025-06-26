//
//  PhotoEditViewController.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/20/25.
//

import UIKit
import PhotosUI


class PhotoEditViewController: UIViewController {
    
    // MARK: - Variable
    private var initialCenter: CGPoint = .zero
    private var editImage: UIImage?
    private let functionItems: [PhotoEditFunction] = [
        PhotoEditFunction(systemName: "photo.badge.plus", title: "사진"),
        PhotoEditFunction(systemName: "character.cursor.ibeam", title: "텍스트")
    ]
    private var selectedSticker: StickerContainerView?
    weak var delegate: PhotoEditViewControllerDelegate?
    var editedImage: UIImage? {
        return renderFinalImage()
    }
    private var editableTextViews: [EditableTextView] = []
    
    
    
    // MARK: - UI Component
    private var backButton: UIButton = UIButton()
    private var saveButton: UIButton = UIButton()
    private var imageView: UIImageView = UIImageView()
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    
    
    init(with editImage:UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.editImage = editImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupUI()
        setupCollectionView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndUnselectTextViews))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboardAndUnselectTextViews() {
        view.endEditing(true) // 키보드 내림 + textViewDidEndEditing 호출
    }
    
    func renderFinalImage() -> UIImage? {
        // 예: imageView 내에 스티커와 배경 이미지가 모두 들어있다고 가정
        let renderer = UIGraphicsImageRenderer(bounds: imageView.bounds)
        return renderer.image { context in
            imageView.layer.render(in: context.cgContext)
        }
    }
}


// MARK: - Extension: setupUI
extension PhotoEditViewController {
    
    private func setupUI() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let backImage = UIImage(systemName: "arrowshape.backward", withConfiguration: imageConfig)
        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .label
        backButton.backgroundColor = .systemBackground
        backButton.layer.cornerRadius = 16
        backButton.layer.masksToBounds = true
        backButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        
        saveButton.setTitle("완료", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        saveButton.setTitleColor(.label, for: .normal)
        saveButton.backgroundColor = .systemBackground
        saveButton.layer.cornerRadius = 8
        saveButton.layer.masksToBounds = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        imageView.image = editImage
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        imageView.addGestureRecognizer(backgroundTap)
        
        view.addSubview(backButton)
        view.addSubview(saveButton)
        view.addSubview(imageView)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            imageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 12),
            imageView.heightAnchor.constraint(equalToConstant: 600),
            
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            saveButton.heightAnchor.constraint(equalToConstant: 32),
            saveButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
    
    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        selectedSticker?.setSelected(false)
        selectedSticker = nil
    }
    
//    @objc func saveButtonTapped() {
//        selectedSticker?.setSelected(false)
//        selectedSticker = nil
//        
//        editableTextViews.forEach { $0.resignTextView() }
//        let renderer = UIGraphicsImageRenderer(bounds: imageView.bounds)
//        let finalImage = renderer.image { ctx in
//            imageView.layer.render(in: ctx.cgContext)
//        }
//        
//        // 다음 RunLoop에서 실행하도록 지연
//        DispatchQueue.main.async {
//            guard let finalImage = self.editedImage else { return }
//            self.delegate?.photoEditViewController(self, didFinishEditing: finalImage)
//            self.dismiss(animated: true)
//        }
//    }
    
    @objc func saveButtonTapped() {
        selectedSticker?.setSelected(false)
        selectedSticker = nil
        editableTextViews.forEach { $0.resignTextView() }

        let renderer = UIGraphicsImageRenderer(bounds: imageView.bounds)
        let finalImage = renderer.image { ctx in
            imageView.layer.render(in: ctx.cgContext)
        }

        // 바로 전달해도 됨 (async 사용은 선택)
        delegate?.photoEditViewController(self, didFinishEditing: finalImage)
        dismiss(animated: true)
    }

}


// MARk: - Extension: UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoEditViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        
        let itemWidth: CGFloat = 80.0
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PhotoEditFunctionCell.self, forCellWithReuseIdentifier: PhotoEditFunctionCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return functionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoEditFunctionCell.reuseIdentifier, for: indexPath) as? PhotoEditFunctionCell else { return UICollectionViewCell() }
        
        let function = functionItems[indexPath.item]
        cell.configure(systemName: function.systemName, title: function.title)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            presentPhotoPicker()
        } else if indexPath.item == 1 {
            print("텍스트필드가 눌림")
            addTextFieldOverlay()
        }
    }
}


// MARK: - Extension: PHPickerViewControllerDelegate
extension PhotoEditViewController: PHPickerViewControllerDelegate {
    
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self,
                      let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    self.addOverlayImage(image)
                }
            }
        }
    }
}


// MARK: - Extension: Pan, Pinch, Rotate Image
extension PhotoEditViewController: UIGestureRecognizerDelegate {
    
    
    // MARK: - Function
    func addOverlayImage(_ image: UIImage) {
        let overlayImageView = StickerContainerView(image: image)
        overlayImageView.center = CGPoint(x: imageView.bounds.midX, y: imageView.bounds.midY)
        overlayImageView.isUserInteractionEnabled = true
        //overlayImageView.frame = CGRect(x: 100, y: 100, width: 150, height: 150)
        //overlayImageView.contentMode = .scaleAspectFill
        
        // 기존 선택 해제
        selectedSticker?.setSelected(false)
        selectedSticker = overlayImageView
        overlayImageView.setSelected(true)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleStickerTap(_:)))
        
        panGesture.delegate = self
        pinchGesture.delegate = self
        rotateGesture.delegate = self
        
        overlayImageView.addGestureRecognizer(panGesture)
        overlayImageView.addGestureRecognizer(pinchGesture)
        overlayImageView.addGestureRecognizer(rotateGesture)
        overlayImageView.addGestureRecognizer(tapGesture)
        
        self.imageView.addSubview(overlayImageView)
        
    }
    
    func addTextFieldOverlay() {
        let textOverlay = EditableTextView(frame: CGRect(x: 100, y: 100, width: 200, height: 40))
        
        // 선택된 텍스트 뷰 외의 것들은 비선택 처리
        textOverlay.onSelect = { [weak self, weak textOverlay] in
            self?.editableTextViews.forEach { $0.setSelected(false) }
            textOverlay?.setSelected(true)
        }
        
        textOverlay.onDelete = { [weak self, weak textOverlay] in
            if let index = self?.editableTextViews.firstIndex(where: { $0 === textOverlay }) {
                self?.editableTextViews.remove(at: index)
            }
        }
        
        imageView.addSubview(textOverlay)
        editableTextViews.append(textOverlay)
    }
    
    
    // MARK: - Action Method
    //    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    //        guard let targetView = gesture.view else { return }
    //
    //        switch gesture.state {
    //        case .began:
    //            initialCenter = targetView.center
    //        case .changed:
    //            let translation = gesture.translation(in: targetView.superview)
    //            targetView.center = CGPoint(
    //                x: initialCenter.x + translation.x,
    //                y: initialCenter.y + translation.y
    //            )
    //        default:
    //            break
    //        }
    //    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let targetView = gesture.view,
              let containerView = targetView.superview else { return }
        
        switch gesture.state {
        case .began:
            initialCenter = targetView.center
            
        case .changed:
            let translation = gesture.translation(in: containerView)
            var newCenter = CGPoint(
                x: initialCenter.x + translation.x,
                y: initialCenter.y + translation.y
            )
            
            // ❗️제한 조건: superview 영역 안에만 이동
            let halfWidth = targetView.bounds.width / 2
            let halfHeight = targetView.bounds.height / 2
            
            let minX = halfWidth
            let maxX = containerView.bounds.width - halfWidth
            let minY = halfHeight
            let maxY = containerView.bounds.height - halfHeight
            
            newCenter.x = min(max(newCenter.x, minX), maxX)
            newCenter.y = min(max(newCenter.y, minY), maxY)
            
            targetView.center = newCenter
            
        default:
            break
        }
    }
    
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
    }
    
    @objc func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    @objc private func handleStickerTap(_ gesture: UITapGestureRecognizer) {
        guard let sticker = gesture.view as? StickerContainerView else { return }
        
        // 이전 스티커 선택 해제
        selectedSticker?.setSelected(false)
        
        // 새로 선택
        selectedSticker = sticker
        sticker.setSelected(true)
    }
    
    @objc func deleteTextView(_ sender: UIButton) {
        guard let container = sender.superview else { return }
        container.removeFromSuperview()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}


// MARK: - Struct
struct PhotoEditFunction {
    let systemName: String
    let title: String
}


// MARK: - Protocol
protocol PhotoEditViewControllerDelegate: AnyObject {
    func photoEditViewController(_ viewController: PhotoEditViewController, didFinishEditing image: UIImage)
    
}


