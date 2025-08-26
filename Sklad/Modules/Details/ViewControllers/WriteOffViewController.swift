//
//  WriteOffViewController.swift
//  Sklad
//
//  Created by Кирилл Котыло on 20.08.25.
//

import UIKit

final class WriteOffViewController: UIViewController {
    
    let writeOffView = WriteOffView()
    
    override func loadView() {
        super.loadView()
        view = writeOffView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        
    }
    
    private func setupConstraints() {
        
    }
}
