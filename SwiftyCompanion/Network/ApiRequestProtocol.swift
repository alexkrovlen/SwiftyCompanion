//
//  ApiRequestProtocol.swift
//  SwiftyCompanion
//
//  Created by Flash Jessi on 9/8/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import Foundation

protocol ApiRequestProtocol {
    
    func getToken()
    
    func checkToken()
    
    func checkUserName(name: String, completion: @escaping (Result<User, Error>) -> Void )
}
