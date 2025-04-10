//
//  ActivityListViewController.swift
//  WellnessActivity
//
//  Created by aymen on 10.04.25.
//

import UIKit
import RxSwift
import RxCocoa

class ActivityListViewController: UIViewController {
    
    private let viewModel: ActivityListViewModel
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView()
    private let addActivityTextField = UITextField()
    private let addActivityButton = UIButton(type: .system)
    
    init(viewModel: ActivityListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Corporate Wellness Activities"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindUI()
    }
    
    private func setupUI() {
        addActivityTextField.placeholder = "Enter new activity"
        addActivityTextField.borderStyle = .roundedRect
        
        addActivityButton.setTitle("Add Activity", for: .normal)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let stackView = UIStackView(arrangedSubviews: [addActivityTextField, addActivityButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        view.addSubview(stackView)
        view.addSubview(tableView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindUI() {
        // Bind add button tap to new activity input.
        addActivityButton.rx.tap
            .withLatestFrom(addActivityTextField.rx.text.orEmpty)
            .filter { !$0.isEmpty }
            .bind(to: viewModel.newActivityTitle)
            .disposed(by: disposeBag)
        
        // Clear the text field after adding an activity.
        viewModel.newActivityTitle
            .subscribe(onNext: { [weak self] _ in
                self?.addActivityTextField.text = ""
            })
            .disposed(by: disposeBag)
        
        // Bind activities to the table view.
        viewModel.activities
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, activity, cell in
                cell.textLabel?.text = activity.title
                cell.detailTextLabel?.text = activity.details
                cell.accessoryType = activity.isCompleted ? .checkmark : .none
            }
            .disposed(by: disposeBag)
        
        // Toggle completion status on cell selection.
        tableView.rx.modelSelected(Activity.self)
            .bind(to: viewModel.toggleActivityCompletion)
            .disposed(by: disposeBag)
        
        // Delete activity on swipe.
        tableView.rx.itemDeleted
            .map { [unowned self] indexPath -> Activity in
                return self.viewModel.activities.value[indexPath.row]
            }
            .bind(to: viewModel.deleteActivity)
            .disposed(by: disposeBag)
        
        // Log any errors.
        viewModel.error
            .subscribe(onNext: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
