//
//  WriteOffViewController.swift
//  Sklad
//
//  Created by Кирилл Котыло on 20.08.25.
//

import UIKit

final class WriteOffViewController: UIViewController {
    
    let writeOffView = WriteOffView()
    var coordinator: DetailsCoordinator?
    
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
        
        navigationController?.navigationBar.isHidden = true
        
        writeOffView.closeButton.addAction(UIAction { [weak self] _ in
            self?.coordinator?.close()
        }, for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer))
        writeOffView.projectPickerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func handleTapGestureRecognizer() {
        coordinator?.goToProjectView()
    }
    
    private func setupConstraints() {
        
    }
}
