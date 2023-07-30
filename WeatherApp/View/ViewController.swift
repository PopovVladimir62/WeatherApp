//
//  ViewController.swift
//  WearherMVVMRx
//
//  Created by Владимир on 24.07.2023.
//

import UIKit
import Combine
import SnapKit

final class ViewController: UIViewController {
    let viewModel = TempViewModel()
    var cancellable: Set<AnyCancellable> = []
    
    //MARK: - UI
    private var cityNameTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "your city"
        textField.textAlignment = .center
        
        return textField
    }()
    
    private var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: .temperatureLabelFontSize)
        label.textAlignment = .center
        
        return label
    }()
    
    private var pressureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: .temperatureLabelFontSize)
        label.textAlignment = .center
        
        return label
    }()

    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameTextField.text = viewModel.city
        view.backgroundColor = .white
        binding()
        setupLayout()
    }

    //MARK: - combine
    private func binding() {
        cityNameTextField.textPublisher
           .assign(to: \.city, on: viewModel)
           .store(in: &cancellable)
       
        viewModel.$currentWeather
           .sink(receiveValue: {[weak self] currentWeather in
               self?.temperatureLabel.text = currentWeather.main?.temp != nil ? "\(Int((currentWeather.main?.temp ?? 0))) ºC" : "incorrect city name"})
           .store(in: &cancellable)
        
        viewModel.$currentWeather
            .sink { [weak self] currentWeather in
                self?.pressureLabel.text = currentWeather.main?.pressure != nil ?
                "\(Int(Double((currentWeather.main?.pressure ?? 0)) * 0.75))mm" : "no pressure"}
            .store(in: &cancellable)
            
    }
    
    //MARK: - layout
    private func setupLayout() {
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        view.addSubview(cityNameTextField)
        cityNameTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(CGFloat.offsetBetweenUI)
            make.top.equalTo(temperatureLabel.snp.bottom).offset(-CGFloat.offsetBetweenUI)
        }
        view.addSubview(pressureLabel)
        pressureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom).offset(CGFloat.offsetBetweenUI)
        }
    }
}


extension ViewController: UISearchTextFieldDelegate {
}

