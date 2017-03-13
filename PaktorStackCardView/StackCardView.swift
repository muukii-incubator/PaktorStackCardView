//
//  StackCardView.swift
//  PaktorStackCardView
//
//  Created by muukii on 3/14/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

public final class StackCardView: UIView {

  private lazy var collectionView: UICollectionView = {
    let layout = PaktorStackCardCollectionViewLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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

    override init(frame: CGRect) {

      super.init(frame: frame)

      let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
      addGestureRecognizer(panGesture)

    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
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
    return 3
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BackdropCell
    #if DEBUG
      cell.contentView.backgroundColor = UIColor(white: 0.7, alpha: 0.5)
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
    attachmentBehavior.damping = 0.4
    attachmentBehavior.length = 0
    attachmentBehavior.action = { [unowned item] in
      // TODO: ここでscale ?
      print(item.center)
    }

    itemBehavior = UIDynamicItemBehavior(items: [item])
    itemBehavior.density = 100
    itemBehavior.resistance = 25

    super.init()

    addChildBehavior(attachmentBehavior)
    addChildBehavior(itemBehavior)
  }

  func set(anchorPoint: CGPoint) {
    attachmentBehavior.anchorPoint = anchorPoint
  }
}
