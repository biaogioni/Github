//
//  ImageUrl.swift
//  Github
//
//  Created by Beatriz Ogioni on 24/07/25.
//

import UIKit

func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        guard
            let data = data,
            let image = UIImage(data: data),
            error == nil
        else {
            completion(nil)
            return
        }

        DispatchQueue.main.async {
            completion(image)
        }
    }.resume()
}
