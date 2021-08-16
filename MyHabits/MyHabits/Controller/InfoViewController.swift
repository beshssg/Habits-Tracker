//
//  InfoViewController.swift
//  MyHabits
//
//  Created by beshssg on 01.08.2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    // MARK: - UIProperties:
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.delegate = self
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.applyTitleStyle()
        label.text = InfoStorage.titleText
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.applyBodyStyle()
        label.numberOfLines = 0
        label.text = InfoStorage.descriptionText
        return label
    }()
    
    // MARK: - Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Информация"
        
        setupLayout()
    }
    
    // MARK: - Methods:
    private func setupLayout() {
        [scrollView, contentView, titleLabel, descriptionLabel].forEach { mask in mask.translatesAutoresizingMaskIntoConstraints = false }
        [titleLabel, descriptionLabel].forEach { contentView.addSubview($0) }
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constraints.indent),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.indent),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constraints.indent),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constraints.indent),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.indent),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constraints.indent),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constraints.indent)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

     // MARK: - Delegate:
extension InfoViewController: UIScrollViewDelegate {
}
