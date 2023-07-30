//
//  ViewModel.swift
//  WearherMVVMRx
//
//  Created by Владимир on 25.07.2023.
//

import Combine
import Foundation

final class TempViewModel {
    // input
    @Published var city: String = "Ryazan"
    // output
    @Published var currentWeather = WeatherDetail.placeholder
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        $city
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { (city:String) -> AnyPublisher <WeatherDetail, Never> in
                WeatherAPI.shared.fetchWeather(for: city)
              }
            .assign(to: \.currentWeather , on: self)
            .store(in: &self.cancellableSet)
    }
}
