//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by beshssg on 01.08.2021.
//

import UIKit

class HabitDetailsViewController: UIViewController, HabitDetailsViewProtocol {
    
    // MARK: - UIProperties:
    var habit = Habit(name: "Выпить стакан воды перед завтраком", date: Date(), color: .systemRed)
    
    private lazy var habitDates: [Date] = {
        HabitsStore.shared.dates.reversed()
    }()
    
    private lazy var imageView: UIImageView? = {
        let image = UIImageView(image: UIImage.init(systemName: "checkmark"))
        image.tintColor = Styles.purpleColor
        return image
    }()
    
    private lazy var habitTableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.register(HabitDetailsTableViewCell.self, forCellReuseIdentifier: String(describing: HabitDetailsTableViewCell.self))
        tb.dataSource = self
        tb.delegate = self
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    // MARK: - Lifecylce:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        
        setupLayout()
    }
    
    // MARK: - Methods: 
    func onHabitDelete() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func onHabitUpdate(habit: Habit) {
        self.habit = habit
        navigationItem.title = habit.name
    }
    
    private func setupLayout() {
        navigationController?.navigationBar.tintColor = Styles.purpleColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(editButtonPressed))
        navigationController!.navigationBar.topItem!.title = "Сегодня"
        navigationItem.title = habit.name
        view.addSubview(habitTableView)
        
        let constraints = [
            habitTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func editButtonPressed() {
        let vc = MyHabitsViewController()
        vc.habit = habit
        vc.habitEditionState = .edition
        vc.nameTextField.text = habit.name
        vc.colorPickerView.backgroundColor = habit.color
        vc.datePicker.date = habit.date
        vc.nameTextField.textColor = habit.color
        vc.habitDetailsViewCallback = self
        navigationController?.present(vc, animated: true, completion: nil)
    }
}

     // MARK: - Delegate:
extension HabitDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HabitDetailsTableViewCell.self),
                                                 for: indexPath) as! HabitDetailsTableViewCell
        cell.textLabel?.text = dateFormatter.string(from: habitDates[indexPath.row])
        
        if HabitsStore.shared.habit(habit, isTrackedIn: habitDates[indexPath.row]) {
            cell.accessoryView = imageView
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "АКТИВНОСТЬ"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
