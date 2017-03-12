//
//  ViewController.swift
//  PaktorStackCardView
//
//  Created by muukii on 3/13/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  private lazy var collectionView: UICollectionView = {
    let layout = PaktorStackCardCollectionViewLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      ])
  }

}
