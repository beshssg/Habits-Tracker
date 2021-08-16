//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by beshssg on 04.08.2021.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIProperties:
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Всё получится!"
        label.applyStatusFootnoteStyle()
        return label
    }()
    
    private var progressSlider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(), for: .normal)
        slider.setValue(HabitsStore.shared.todayProgress, animated: true)
        slider.tintColor = Styles.purpleColor
        return slider
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.applyStatusFootnoteStyle()
        label.text = String(Int(HabitsStore.shared.todayProgress * 100)) + "%"
        return label
    }()
    
    // MARK: - Init:
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    // MARK: - Methods:
    func show() {
        progressSlider.setValue(HabitsStore.shared.todayProgress, animated: true)
        statusLabel.text = String(Int(HabitsStore.shared.todayProgress * 100)) + "%"
    }
    
    private func setupLayout() {
        [nameLabel, progressSlider, statusLabel].forEach { mask in mask.translatesAutoresizingMaskIntoConstraints = false }
        [nameLabel, progressSlider, statusLabel].forEach { contentView.addSubview($0) }
        contentView.roundCornerWithRadius(4, top: true, bottom: true, shadowEnabled: false)
        contentView.backgroundColor = .white
        
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constraints.indent3),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.indent4),
            
            progressSlider.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constraints.indent3),
            progressSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constraints.indent4),
            progressSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.indent4),
            progressSlider.heightAnchor.constraint(equalToConstant: Constraints.indent5),
            progressSlider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constraints.indent - 1),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: progressSlider.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
