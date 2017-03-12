//
//  PaktorStackCardCollectionViewLayout.swift
//  PaktorStackCardView
//
//  Created by muukii on 3/13/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

public final class PaktorStackCardCollectionViewLayout: UICollectionViewLayout {

  public override var collectionViewContentSize: CGSize {
    return collectionView?.bounds.size ?? .zero
  }
}
