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

    let startItem = 0
    let frame = collectionView!.bounds.insetBy(dx: 16, dy: 100)
    let shrink: CGFloat = 0.05
    let offset: CGFloat = 36

    let attributeses = (0..<3).map { item -> StackCardLayoutAttributes in

      let indexPath = IndexPath(item: startItem + item, section: 0)
      let diff = shrink * CGFloat(item)
      let offset = -offset * CGFloat(item)
      let attributes = StackCardLayoutAttributes(forCellWith: indexPath)
      attributes.frame = frame
      attributes.transform = CGAffineTransform(scaleX: 1 - diff, y: 1 - diff).translatedBy(x: 0, y: offset)
      attributes.zIndex = -item
      return attributes
    }

    return attributeses
  }

  public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return nil
  }

  public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

}

final class StackCardLayoutAttributes: UICollectionViewLayoutAttributes {

}
