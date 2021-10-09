//
//  ApiRequest.swift
//  SwiftyCompanion
//
//  Created by Flash Jessi on 9/8/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case noData
    case tokenError
    case underfined
}

class ApiRequest: ApiRequestProtocol {
    
    let groupDispatch = DispatchGroup()
    var errorAction: ((ApiError) -> ())?
    let config = ["grant_type": "client_credentials",
                  "client_id": "589ca341f45771bbad6fdd7aec9c13edb447532ebb9c1d581a4f05f185e15f40",
                  "client_secret": "9ae2759aacbe9001dd32843f59531fdef5a72dbc5aec2e71c2306f596cf1457c"]
    
    func getToken() {
        DispatchQueue.global().async {
            guard let url = URL(string: "https://api.intra.42.fr/oauth/token") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: self.config, options: []) else { return }
            request.httpBody = httpBody
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print("response get token:\(response)")
                }
                
                guard let data = data else {
                    self.errorAction?(.noData)
                    return
                }
                do {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    guard
                        let json = jsonObject as? [String: Any],
                        let accessToken = json["access_token"] as? String
                        else {
                            self.errorAction?(.noData)
                            print("Error: Unable to get access token" + error!.localizedDescription)
                            self.groupDispatch.leave()
                            return
                    }
                    UserDefaults.standard.set(accessToken, forKey: "token")
                    print("access token:" + accessToken)
                    self.groupDispatch.leave()
                }
            }
            dataTask.resume()
        }
    }
    
    
    func checkToken() {
        DispatchQueue.global().async {
            if let token = UserDefaults.standard.string(forKey: "token"){
                guard let url = URL(string: "https://api.intra.42.fr/oauth/token/info?&access_token=\(token)") else { return }
                let urlRequest = URLRequest(url: url)
                let session = URLSession.shared
                let dataTask = session.dataTask(with: urlRequest) { data, response, error in
                    if let response = response {
                        print("response check token:\(response)")
                    }
                    
                    guard let data = data else {
                        self.errorAction?(.tokenError)
                        return
                    }
                    do {
                        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                        guard
                            let json = jsonObject as? [String: Any],
                            let expiresInSeconds = json["expires_in_seconds"] as? Int
                            else {
                                print("Your access token is invalid. Create a new access token.")
                                self.getToken()
                                return
                        }
                        print("Your current access token is valid for another \(expiresInSeconds) sec.")
                        self.groupDispatch.leave()
                    }
                }
                dataTask.resume()
            } else {
                self.getToken()
            }
        }
    }
    
    func checkUserName(name: String, completion: @escaping (Result<User, Error>) -> Void) {
        let tok = UserDefaults.standard.string(forKey: "token")
        groupDispatch.enter()
        if tok == nil {
            self.getToken()
        } else {
            self.checkToken()
        }
        let result = groupDispatch.wait(timeout: .now() + 10)
        if result == .timedOut {
            completion(.failure(ApiError.noData))
            return
        }
        print("result = \(result)")
        
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        print("token user: \(token)")
        
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(name)?&access_token=\(token)") else { return }
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if let response = response {
                print("response user:\(response)")
            }
            if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(.failure(ApiError.underfined))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.noData))
                return
            }
            
            let decoder = JSONDecoder()
            DispatchQueue.main.async {
                do {
                    let response = try decoder.decode(User.self, from: data)
                    //                print("resp: \(response)")
                    completion(.success(response.self))
                } catch {
                    completion(.failure(ApiError.noData))
                }
            }
        })
        dataTask.resume()
    }
}
