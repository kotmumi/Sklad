//
//  ReturnIteemAlertViewController.swift
//  Sklad
//
//  Created by Кирилл Котыло on 29.09.25.
//

import UIKit
import Combine

final class ReturnIteemAlertViewController: UIViewController {
    
    private let viewModel: DetailsViewModel
    private var cancelables: Set<AnyCancellable> = []
    var coordinator: DetailsCoordinator?
    let writeOffView = ReturnItemAlertView()
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = writeOffView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
}

extension ReturnIteemAlertViewController {
    
    private func setupUI() {
        writeOffView.okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        writeOffView.okButton.isEnabled = false
        writeOffView.okButton.showLoading()
    }
    
    @objc private func okButtonTapped() {
        viewModel.relode.send()
        dismiss(animated: true)
    }
    
    private func finishLoading() {
        writeOffView.okButton.isEnabled = true
        writeOffView.okButton.hideLoading()
        writeOffView.okButton.setTitle("Принять", for: .normal)
    }
    
    private func bind() {
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.finishLoading()
            }
            .store(in: &cancelables)
    }
}
