//
//  Manager.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/17/25.
//

import Foundation
import AVFoundation
import Photos


final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}
    
    var cachedImageURLs: [Int: URL] = [:]
    
    func preloadImages(forDays days: Int) {
        for day in 1...days {
            if cachedImageURLs[day] == nil {
                if let url = URL(string: "https://picsum.photos/800/1200?random=\(UUID().uuidString)") {
                    cachedImageURLs[day] = url
                }
            }
        }
    }
    
    func url(for day: Int) -> URL? {
        return cachedImageURLs[day]
    }
}


// 카메라 및 앨범 접근권한 설정
enum MediaPermissionType {
    case camera
    case album
}

final class MediaPermissionManager {
    
    // MARK: - Variable
    static let shared = MediaPermissionManager()
    
    private init() { }
    
    
    // MARK: - Function
    func request(_ type: MediaPermissionType, completion: @escaping (Bool) -> Void) {
        switch type {
        case .camera:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .album:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized, .limited:
                        completion(true)
                    default:
                        completion(false)
                    }
                }
            }
        }
    }
    
    func checkStatus(_ type: MediaPermissionType) -> Bool {
        switch type {
        case .camera:
            return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        case .album:
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            return status == .authorized || status == .limited
        }
    }
    
    // 권한 상태 확인 후 필요 시 요청까지 수행하는 통합 메서드
    func checkAndRequestIfNeeded(_ type: MediaPermissionType, completion: @escaping (Bool) -> Void) {
        if checkStatus(type) {
            completion(true)
            return
        }
        
        // 아직 요청 안했거나 거부된 경우 -> 요청 시도
        request(type) { granted in
            completion(granted)
        }
    }
}
