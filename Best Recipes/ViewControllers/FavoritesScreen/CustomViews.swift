//
//  CustomViews.swift
//  Best Recipes
//
//  Created by artyom s on 15.08.2025.
//

import UIKit

final class CircleButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    
}

final class CircleImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}


final class ScoreLabel: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .poppinsSemiBold(size: 17)
        return label
    }()
    private let icon = UIImageView(image: .star)
    private var blurView: UIVisualEffectView
    
    func configure( ratingValue: Double) {
        label.text = "\(ratingValue)"
    }
    
    
    init(blurStyle: UIBlurEffect.Style = .systemUltraThinMaterial) {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        super.init(frame: .zero)
        setup()
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.layer.cornerRadius = 10
    }
    
    
    private func setup() {
        label.textColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(blurView)
        blurView.contentView.addSubview(icon)
        blurView.contentView.addSubview(label)
        [icon, label].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false}
        
        blurView.pinEdgesToView(self)
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 8),
            icon.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 8),
            icon.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -8),
            icon.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8),
            
            icon.widthAnchor.constraint(equalToConstant: 12),
            icon.heightAnchor.constraint(equalToConstant: 12),
            
            label.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -8)
            
        ])
    }
    
    
}



final class TimeLabel: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .poppinsRegular(size: 17)
        return label
    }()
    
    private let blurView: UIVisualEffectView
    
    func configure( timeText: String) {
        label.text = timeText
    }
    
    init(blurStyle: UIBlurEffect.Style = .systemUltraThinMaterial) {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        super.init(frame: .zero)
        label.textColor = .white
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurView.layer.cornerRadius = 10
    }
    
    
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        blurView.contentView.addSubview(label)
        
        
        label.textAlignment = .center
        label.numberOfLines = 0
        
        blurView.pinEdgesToView(self)
        
        // Constraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -4),
            label.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -4)
        ])
    }
}

