//
//  Helper.swift
//  PhotoDiary
//
//  Created by 권정근 on 6/17/25.
//

import Foundation
import UIKit


/// 컬렉션뷰의 셀 중앙 정렬 기능 구현 
class CenterSnapFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else { return proposedContentOffset }

        let collectionViewSize = collectionView.bounds.size
        let proposedRect = CGRect(origin: proposedContentOffset, size: collectionViewSize)

        guard let layoutAttributes = super.layoutAttributesForElements(in: proposedRect) else {
            return proposedContentOffset
        }

        let centerX = proposedContentOffset.x + collectionView.bounds.width / 2

        var minOffsetAdjustment = CGFloat.greatestFiniteMagnitude
        for attributes in layoutAttributes {
            let itemCenterX = attributes.center.x
            let offsetAdjustment = itemCenterX - centerX
            if abs(offsetAdjustment) < abs(minOffsetAdjustment) {
                minOffsetAdjustment = offsetAdjustment
            }
        }

        return CGPoint(x: proposedContentOffset.x + minOffsetAdjustment, y: proposedContentOffset.y)
    }
}
