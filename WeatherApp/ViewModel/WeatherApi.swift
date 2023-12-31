//
//  WeatherApi.swift
//  WearherMVVMRx
//
//  Created by Владимир on 25.07.2023.
//

import Foundation
import Combine
import UIKit

final class WeatherAPI {
    static let shared = WeatherAPI()
    
    private let baseaseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "741f2c87bff4ffc1c5f4fd4d75a60c30"
    
    private func absoluteURL(city: String) -> URL? {
        let queryURL = URL(string: baseaseURL)!
        let components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        guard var urlComponents = components else { return nil }
        urlComponents.queryItems = [URLQueryItem(name: "appid", value: apiKey),
                                    URLQueryItem(name: "q", value: city),
                                    URLQueryItem(name: "units", value: "metric")]
        return urlComponents.url
    }
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherDetail, Never> {
        guard let url = absoluteURL(city: city) else { return Just(WeatherDetail.placeholder).eraseToAnyPublisher() }
        print(url)
        return URLSession.shared.dataTaskPublisher(for:url)
            .map { $0.data }
            .decode(type: WeatherDetail.self, decoder: JSONDecoder())
            .catch { error in Just(WeatherDetail.placeholder)}
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
