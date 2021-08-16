//
//  HabitProtocol.swift
//  MyHabits
//
//  Created by beshssg on 03.08.2021.
//

import UIKit

protocol UpdateCollectionProtocol {
    func onCollectionUpdate()
}

protocol HabitDetailsViewProtocol {
    func onHabitUpdate(habit: Habit)
    func onHabitDelete()
}

protocol HabitTapCallback {
    func onTap(position: Int)
}

enum HabitEditionState {
    case creation
    case edition
}
