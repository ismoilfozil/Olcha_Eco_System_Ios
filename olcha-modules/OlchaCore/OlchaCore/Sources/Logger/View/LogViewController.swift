//
//  LogViewController.swift
//  OlchaCore
//
//  Created by Elbek Khasanov on 01/05/23.
//

import UIKit

public class LogViewController: UIViewController {
    
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        textView.text = " MY TEXTSS \n dfsadasda\nasdasdas\nadasdasd"
        textView.font = .systemFont(ofSize: 16, weight: .medium)
        return textView
    }()
    
    var model: LogModel? {
        didSet {
            textView.text = """
                        URL: \(model?.url ?? "")
                        TYPE: \(model?.requestType ?? "")
                        HEADER: \(model?.header ?? "")
                        
                        
                        BODY: \(model?.body ?? "")
                        
                        
                        RESPONSE: \(model?.response ?? "")
                        
                        """
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        
        view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    
}
