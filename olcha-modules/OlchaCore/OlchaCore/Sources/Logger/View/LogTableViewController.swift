//
//  LogTableViewController.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 01/05/23.
//

import UIKit

public class LogTableViewController: UIViewController {
    
    
    private lazy var table: UITableView = {
        let table = UITableView()
        
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "LogCell", bundle: Bundle(identifier: "com.olcha.OlchaCore")), forCellReuseIdentifier: "LogCell")
        table.estimatedRowHeight = UITableView.automaticDimension
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    public var changeBaseURL: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(table)


        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clear))
        
        let changeButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(change))
                                          
        navigationItem.rightBarButtonItems = [
            addButton,
            changeButton
        ]
        
        LogDB.shared.logsAppended = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func clear() {
        LogDB.shared.logs.removeAll()
        table.reloadData()
    }
    
    @objc func empty() {
     
    }
    
    @objc func change() {
        changeBaseURL?()
    }
    
}

extension LogTableViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LogDB.shared.logs.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as? LogCell else { return .init() }
        
        cell.setup(model: LogDB.shared.logs[indexPath.row])
        
        return cell
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = LogViewController()
        vc.model = LogDB.shared.logs[indexPath.row]
        self.present(vc, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
