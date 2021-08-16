//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by beshssg on 01.08.2021.
//

import UIKit

class HabitsViewController: UIViewController, UpdateCollectionProtocol {
    
    // MARK: - UIProperties:
    private lazy var habitStore: HabitsStore = HabitsStore.shared
    
    private lazy var habitsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Styles.lightGrayColor
        cv.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        cv.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.imageView?.sizeToFit()
        button.imageView?.tintColor = Styles.purpleColor
        button.addTarget(self, action: #selector(tapAddButton), for: .touchUpInside)
        return button
    } ()
    
    private lazy var todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Сегодня"
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        habitsCollectionView.reloadData()
        setupLayout()

        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Methods:
    func onCollectionUpdate() {
        habitsCollectionView.reloadData()
    }
    
    @objc func tapAddButton() {
        let vc = MyHabitsViewController()
        vc.updateCollectionCallback = self
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    private func setupLayout() {
        [habitsCollectionView, todayLabel, addButton].forEach { mask in mask.translatesAutoresizingMaskIntoConstraints = false }
        [habitsCollectionView, todayLabel, addButton].forEach { view.addSubview($0) }
        
        let constraints = [
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            
            habitsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            habitsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            habitsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habitsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            todayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            todayLabel.bottomAnchor.constraint(equalTo: habitsCollectionView.topAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

     // MARK: - Delegate:
extension HabitsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            return
        }
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = HabitDetailsViewController()
        vc.habit = habitStore.habits[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return habitStore.habits.count
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let progressCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProgressCollectionViewCell.self),
                                                                  for: indexPath) as! ProgressCollectionViewCell
            progressCell.show()
            return progressCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HabitCollectionViewCell.self),
                                                          for: indexPath) as! HabitCollectionViewCell
            cell.setData(habit: habitStore.habits[indexPath.item])
            cell.habitTapCallback = { [weak self] in self?.habitsCollectionView.reloadData() }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat
        if indexPath.section == 0 {
            height = 60
        } else {
            height = 130
        }
        return .init(width: (UIScreen.main.bounds.width - 32), height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int)
    -> UIEdgeInsets {
        let top: CGFloat
        let bottom: CGFloat
        if section == 0 {
            top = 22
            bottom = 6
        } else {
            top = 18
            bottom = 12
        }
        return UIEdgeInsets(top: top, left: 16, bottom: bottom, right: 16)
    }
}



