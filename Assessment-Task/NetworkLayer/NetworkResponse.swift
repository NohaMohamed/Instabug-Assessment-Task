//
//  NetworkResponse.swift
//  Assessment-Task
//
//  Created by Noha  on 2/23/19.
//  Copyright © 2019 Noha . All rights reserved.
//

enum NetworkResponse: String {
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}
