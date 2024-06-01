//
//  MultipartFormProvider.swift
//  InnoviticsNetworkLayer
//
//  Created by ahmed moharam on 31/05/2024.
//
//

import Alamofire

class MultipartFormProvider {

    // MARK: - Public Methods
    
    static func multiPartHandler(
        parameters: [String: String]? = nil,
        imageKey: String,
        images: [Data]
    ) -> MultipartFormData {
        
        let formData = MultipartFormData()
        
        // Add parameters to formData if available
        if let parameters = parameters {
            for (key, value) in parameters {
                if let data = value.data(using: .utf8) {
                    formData.append(data, withName: key)
                }
            }
        }
        
        // Add images to formData if available
        for (index, data) in images.enumerated() where !data.isEmpty {
            formData.append(data, withName: imageKey, fileName: "avatar\(index).jpeg", mimeType: "image/jpeg")
        }
        
        return formData
    }
}
