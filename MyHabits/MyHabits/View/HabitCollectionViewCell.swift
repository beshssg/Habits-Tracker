//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by beshssg on 01.08.2021.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIProperties:
    var habitTapCallback: (() -> Void)?
    
    var habit = Habit(name: "Выпить стакан воды перед завтраком", date: Date(), color: .systemRed)
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.applyHeadlineStyle()
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.applyFootnoteStyle()
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.applyCaptionStyle()
        label.text = "Счётчик: \(habit.trackDates.count)"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.roundCornerWithRadius(18, top: true, bottom: true, shadowEnabled: false)
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(checkButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        let image = UIImageView(image: UIImage.init(systemName: "checkmark"))
        image.tintColor = .white
        return image
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
    @objc func checkButtonPressed() {
        if !habit.isAlreadyTakenToday {
            HabitsStore.shared.track(habit)
            checkButton.backgroundColor = habit.color
        }
        habitTapCallback?()
        checkmarkImageView.isHidden = !habit.isAlreadyTakenToday
    }
    
    func setData(habit: Habit) {
        self.habit = habit
        nameLabel.textColor = habit.color
        nameLabel.text = habit.name
        dateLabel.text = habit.dateString
        checkButton.layer.borderColor = habit.color.cgColor
        trackerLabel.text = "Счётчик: \(habit.trackDates.count)"
        checkmarkImageView.isHidden = !habit.isAlreadyTakenToday
        
        if habit.isAlreadyTakenToday {
            checkButton.backgroundColor = habit.color
        } else {
            checkButton.backgroundColor = .white
        }
    }
    
    private func setupLayout() {
        [nameLabel, dateLabel, trackerLabel, checkButton, checkmarkImageView].forEach { mask in
            mask.translatesAutoresizingMaskIntoConstraints = false }
        [nameLabel, dateLabel, trackerLabel, checkButton, checkmarkImageView].forEach { contentView.addSubview($0) }
        contentView.roundCornerWithRadius(6, top: true, bottom: true, shadowEnabled: false)
        contentView.backgroundColor = .white
        
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constraints.indent2),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.indent2),
            nameLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: -Constraints.indent2),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constraints.indent5 - 3),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            trackerLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            trackerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constraints.indent2),
            
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constraints.indent2 - 6),
            checkButton.heightAnchor.constraint(equalToConstant: Constraints.imageSize),
            checkButton.widthAnchor.constraint(equalToConstant: Constraints.imageSize),
            checkButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constraints.imageSize - 11),
  
            checkmarkImageView.centerXAnchor.constraint(equalTo: checkButton.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
