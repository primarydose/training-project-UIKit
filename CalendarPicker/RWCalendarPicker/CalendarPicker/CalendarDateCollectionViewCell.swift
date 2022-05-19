

import UIKit

class CalendarDateCollectionViewCell: UICollectionViewCell {
  static let reuseIdentifier = String(describing: CalendarDateCollectionViewCell.self)
  
  // MARK: - Property
  
  var day: Day? {
    didSet {
      guard let day = day else { return }
      numberLabel.text = day.number
      accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
      updateSelectionStatus()
    }
  }
  
  // MARK: - View
  
  private lazy var selectionBackgroundView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.clipsToBounds = true
    view.backgroundColor = .systemRed
    return view
  }()
  
  private lazy var numberLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.textColor = .label
    return label
  }()
  
  private lazy var accessibilityDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .gregorian)
    dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
    return dateFormatter
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    isAccessibilityElement = true
    accessibilityTraits = .button
    contentView.addSubview(selectionBackgroundView)
    contentView.addSubview(numberLabel)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    
    let size = traitCollection.horizontalSizeClass == .compact ? min(min(frame.width, frame.height) - 10, 60) : 45
    
    NSLayoutConstraint.activate([
      numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
      selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
      selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
      selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor)
    ])
    
    selectionBackgroundView.layer.cornerRadius = size / 2
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    layoutSubviews()
  }
}

// MARK: - Appearance
private extension CalendarDateCollectionViewCell {
  // apply a different style to the cell based on the selection status of the day
  func updateSelectionStatus() {
    guard let day = day else { return }
    
    if day.isSelected {
      applySelectedStyle()
    } else {
      applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth)
    }
  }
    
    // add a computed property that determenis if the screen size has a limited of width
    var isSmallScreenSize: Bool {
      let isCompact = traitCollection.horizontalSizeClass == .compact
      let smallWidth = UIScreen.main.bounds.width <= 350
      let widthGreaterThanHeight = UIScreen.main.bounds.width > UIScreen.main.bounds.height
      return isCompact && (smallWidth || widthGreaterThanHeight)
    }
    
    // applies when the user selects the cell, based on the screen size
    func applySelectedStyle() {
      accessibilityTraits.insert(.selected)
      accessibilityHint = nil
      
      numberLabel.textColor = isSmallScreenSize ? .systemRed: .white
      selectionBackgroundView.isHidden = isSmallScreenSize
    }
  
  // apllies a default style to the cell
  func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
    accessibilityTraits.remove(.selected)
    accessibilityHint = "Tap to select"
    numberLabel.textColor = isWithinDisplayedMonth ? .label : .secondaryLabel
    selectionBackgroundView.isHidden = true
  }
}
