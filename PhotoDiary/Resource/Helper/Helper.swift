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


/// 버튼의 터치범위 늘리는 방식
//class EnlargedHitAreaButton: UIButton {
//    var hitAreaInset = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
//
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        let largerArea = bounds.inset(by: hitAreaInset)
//        return largerArea.contains(point)
//    }
//}


class EnlargedHitAreaButton: UIButton {
    var hitAreaInset: UIEdgeInsets = .zero

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let largerArea = bounds.inset(by: hitAreaInset.inverted())
        return largerArea.contains(point)
    }
}

private extension UIEdgeInsets {
    func inverted() -> UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}
