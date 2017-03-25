//
//  StackCardView.swift
//  PaktorStackCardView
//
//  Created by muukii on 3/14/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

public protocol StackCardViewDataSource: class {
  func numberOfCards(stackCardView: StackCardView) -> Int
  func stackCardView(_ stackCardView: StackCardView, cardForAt index: Int) -> UIView
}

public protocol StackCardViewDelegate: class {

}

public final class StackCardView: UIView {

  public weak var dataSource: StackCardViewDataSource?

  fileprivate let layout = PaktorStackCardCollectionViewLayout()

  fileprivate lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
    collectionView.backgroundColor = .clear
    collectionView.register(BackdropCell.self, forCellWithReuseIdentifier: "Cell")
    return collectionView
  }()

  public override init(frame: CGRect) {
    super.init(frame: frame)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor),
      collectionView.leftAnchor.constraint(equalTo: leftAnchor),
      ])

    collectionView.dataSource = self
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  fileprivate class BackdropCell: UICollectionViewCell {

    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: UIApplication.shared.keyWindow!) // FIXME:
    private lazy var behavior: AttachmentBehavior<BackdropCell> = AttachmentBehavior(item: self)

    var didTap: () -> Void = {}

    let label = UILabel()

    override init(frame: CGRect) {

      super.init(frame: frame)

      let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
      addGestureRecognizer(panGesture)

      label.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(label)

      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
      label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

      let tap = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
      contentView.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    @objc func tap(gesture: UITapGestureRecognizer) {
      didTap()
    }

    @objc func pan(gesture: UIPanGestureRecognizer) {
      switch gesture.state {
      case .began:

        behavior.set(anchorPoint: self.center)
        animator.removeBehavior(behavior)

      case .changed:

        let point = gesture.translation(in: gesture.view)

        self.center = self.center.applying(CGAffineTransform(translationX: point.x, y: point.y))

        gesture.setTranslation(.zero, in: gesture.view)

      case .ended, .failed, .cancelled:

        behavior.setVelocity(velocity: gesture.velocity(in: self))
        self.animator.addBehavior(behavior)

      default:
        break
      }
    }
  }
}

extension StackCardView: UICollectionViewDataSource {

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource?.numberOfCards(stackCardView: self) ?? 0
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    print(indexPath)

    guard let card = dataSource?.stackCardView(self, cardForAt: indexPath.item) else {
      return UICollectionViewCell()
    }

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BackdropCell
    #if DEBUG
      cell.contentView.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
      cell.label.text = String(describing: indexPath)
      cell.didTap = { [weak self] in
        self?.layout.next()
      }
    #endif
    return cell
  }
}

final class AttachmentBehavior<T: UIDynamicItem>: UIDynamicBehavior {

  let attachmentBehavior: UIAttachmentBehavior
  let itemBehavior: UIDynamicItemBehavior
  let item: T

  func setVelocity(velocity: CGPoint) {

    let currentVelocity = itemBehavior.linearVelocity(for: item)
    itemBehavior.addLinearVelocity(CGPoint(x: velocity.x - currentVelocity.x, y: velocity.y - currentVelocity.y), for: item)
  }

  init(item: T) {

    self.item = item

    let point = item.center
    attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: point)
    attachmentBehavior.frequency = 4
    attachmentBehavior.damping = 0.8
    attachmentBehavior.length = 0
    attachmentBehavior.action = { [unowned item] in

    }

    itemBehavior = UIDynamicItemBehavior(items: [item])
    itemBehavior.density = 300
    itemBehavior.resistance = 50

    super.init()

    addChildBehavior(attachmentBehavior)
    addChildBehavior(itemBehavior)
  }

  func set(anchorPoint: CGPoint) {
    attachmentBehavior.anchorPoint = anchorPoint
  }
}
