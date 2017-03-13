//
//  ViewController.swift
//  PaktorStackCardView
//
//  Created by muukii on 3/13/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  private lazy var stackCardView = StackCardView(frame: .zero)

  override func viewDidLoad() {
    super.viewDidLoad()

    stackCardView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackCardView)

    NSLayoutConstraint.activate([
      stackCardView.topAnchor.constraint(equalTo: view.topAnchor),
      stackCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackCardView.rightAnchor.constraint(equalTo: view.rightAnchor),
      stackCardView.leftAnchor.constraint(equalTo: view.leftAnchor),
      ])
  }
}
