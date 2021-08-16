//
//  MyHabitsViewController.swift
//  MyHabits
//
//  Created by beshssg on 01.08.2021.
//

import UIKit

class MyHabitsViewController: UIViewController {
    
    // MARK: - UIProperties:
    var habitEditionState = HabitEditionState.creation
    
    var updateCollectionCallback: UpdateCollectionProtocol?
    
    var habitDetailsViewCallback: HabitDetailsViewProtocol?
    
    var habit = Habit(name: "Выпить стакан воды перед завтраком", date: Date(), color: .systemRed)
    
    private lazy var habitStore: HabitsStore = {
        return HabitsStore.shared
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "НАЗВАНИЕ"
        label.applyFootnoteStyle()
        label.numberOfLines = 1
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return textField
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "ЦВЕТ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    lazy var colorPickerView: UIView = {
        let view = UIView()
        view.roundCornerWithRadius(15, top: true, bottom: true, shadowEnabled: false)
        view.backgroundColor = habit.color
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapColorPicker))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var colorPickerViewController: UIColorPickerViewController = {
        let vc = UIColorPickerViewController()
        vc.delegate = self
        return vc
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "ВРЕМЯ"
        label.applyFootnoteStyle()
        return label
    }()
    
    lazy var habitTimeLabelText: UILabel = {
        let label = UILabel()
        label.text = "Каждый день в"
        return label
    }()
    
    lazy var habitTimeLabelTime: UILabel = {
        let label = UILabel()
        label.text = " \(dateFormatter.string(from: datePicker.date))"
        label.tintColor = Styles.purpleColor
        label.textColor = Styles.purpleColor
        return label
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private lazy var deleteHabitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить привычку", for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecylce:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLayout()
    }
    
    // MARK: - Methods:
    @objc func datePickerChanged(picker: UIDatePicker) {
        if habitEditionState == .creation {
            habit.date = datePicker.date
        }
        habitTimeLabelTime.text = " \(dateFormatter.string(from: datePicker.date))"
    }
    
    @objc func tapColorPicker() {
        present(colorPickerViewController, animated: true, completion: nil)
    }
    
    @objc func actionCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func actionSaveButton() {
        habit.name = nameTextField.text ?? habit.name
        if let color = colorPickerView.backgroundColor {
            habit.color = color
        }
        
        switch habitEditionState {
        case .creation:
            do {
                let store = HabitsStore.shared
                store.habits.append(habit)
            }
        case .edition:
            do {
                habit.date = datePicker.date
            }
        }
        habitStore.save()
        updateCollectionCallback?.onCollectionUpdate()
        habitDetailsViewCallback?.onHabitUpdate(habit: habit)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteButtonPressed() {
        let alertController = UIAlertController(title: "Удалить привычку",
                                                message: "Вы хотите удалить привычку \(habit.name)",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in }
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            HabitsStore.shared.habits.remove(at: HabitsStore.shared.habits.firstIndex(of: self.habit)!)
            self.habitDetailsViewCallback?.onHabitDelete()
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupLayout() {
        let navBar = UINavigationBar()
        
        [navBar, datePicker, nameLabel, nameTextField, colorLabel, colorPickerView, timeLabel, habitTimeLabelText, habitTimeLabelTime,
         deleteHabitButton].forEach { mask in mask.translatesAutoresizingMaskIntoConstraints = false }
        
        [navBar, datePicker, nameLabel, nameTextField, colorLabel, colorPickerView, timeLabel, habitTimeLabelText,habitTimeLabelTime].forEach { view.addSubview($0)
        }
        
        let constraintsNavBar = [
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),
            navBar.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraintsNavBar)
        
        let navItem = UINavigationItem()
        
        let leftBarButtonItem = UIBarButtonItem(title: "Отменить",
                                                style: UIBarButtonItem.Style.plain,
                                                target: self,
                                                action: #selector(actionCancelButton))
        
        let rightBarButtonItem = UIBarButtonItem(title: "Сохранить",
                                                 style: UIBarButtonItem.Style.done,
                                                 target: self,
                                                 action: #selector(actionSaveButton))
        
        leftBarButtonItem.tintColor = Styles.purpleColor
        rightBarButtonItem.tintColor = Styles.purpleColor
        
        navItem.rightBarButtonItem = rightBarButtonItem
        navItem.leftBarButtonItem = leftBarButtonItem
        
        switch habitEditionState {
        case .creation: navItem.title = "Создать"
        case .edition: navItem.title = "Править"
    }
        
        navBar.setItems([navItem], animated: true)
        navBar.backgroundColor = .systemGray

        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: Constraints.indent2 + 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.indent),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constraints.indent5),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constraints.indent),
            
            colorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: Constraints.indent - 1),
            colorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            colorPickerView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: Constraints.indent5),
            colorPickerView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            colorPickerView.heightAnchor.constraint(equalToConstant: Constraints.imageSize2),
            colorPickerView.widthAnchor.constraint(equalToConstant: Constraints.imageSize2),
            
            timeLabel.topAnchor.constraint(equalTo: colorPickerView.bottomAnchor, constant: Constraints.indent - 1),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            habitTimeLabelText.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: Constraints.indent5),
            habitTimeLabelText.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            habitTimeLabelTime.topAnchor.constraint(equalTo: habitTimeLabelText.topAnchor),
            habitTimeLabelTime.leadingAnchor.constraint(equalTo: habitTimeLabelText.trailingAnchor),
            
            datePicker.topAnchor.constraint(equalTo: habitTimeLabelText.bottomAnchor, constant: Constraints.indent - 1),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        if habitEditionState == .edition {
            self.view.addSubview(self.deleteHabitButton)
            
            let constraintButton = [
                deleteHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constraints.indent5 - 1),
                deleteHabitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ]
            NSLayoutConstraint.activate(constraintButton)
        }
    }
}

     // MARK: - Delegate:
extension MyHabitsViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        habit.color = colorPickerViewController.selectedColor
        colorPickerView.backgroundColor = colorPickerViewController.selectedColor
    }
}

