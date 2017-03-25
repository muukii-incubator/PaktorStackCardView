//
//  PaktorStackCardCollectionViewLayout.swift
//  PaktorStackCardView
//
//  Created by muukii on 3/13/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

public final class PaktorStackCardCollectionViewLayout: UICollectionViewLayout {

  // MARK: - Properties

  public func next() {
    currentIndex += 1
    collectionView?.performBatchUpdates({
    }, completion: nil)
  }

  public var currentIndex: Int = 0

  open override class var layoutAttributesClass: Swift.AnyClass {
    return StackCardLayoutAttributes.self
  }

  public override var collectionViewContentSize: CGSize {
    return collectionView?.bounds.size ?? .zero
  }

  // MARK: - Functions

  public override func prepare() {

  }

  public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    let attributeses = (0..<3).flatMap { item in
      layoutAttributesForItem(at: IndexPath(item: currentIndex + item, section: 0))
      }

    return attributeses
  }

  public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

    let item = indexPath.item - currentIndex

    let shrink: CGFloat = 0.05
    let offset: CGFloat = 36
    let frame = collectionView!.bounds.insetBy(dx: 16, dy: 100)

    let indexPath = IndexPath(item: currentIndex + item, section: 0)
    let diff = shrink * CGFloat(item)
    let _offset = -offset * CGFloat(item)
    let attributes = StackCardLayoutAttributes(forCellWith: indexPath)
    attributes.frame = frame
    attributes.transform = CGAffineTransform(scaleX: 1 - diff, y: 1 - diff).translatedBy(x: 0, y: _offset)
    attributes.zIndex = -(indexPath.item)

    if item < 0 {
      attributes.alpha = 0
      attributes.isHidden = true
    } else {
      attributes.alpha = 1
      attributes.isHidden = false
    }

    return attributes
  }

  public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return false
  }
}

final class StackCardLayoutAttributes: UICollectionViewLayoutAttributes {

}
