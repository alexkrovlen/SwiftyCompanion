//
//  SearchViewController.swift
//  SwiftyCompanion
//
//  Created by Flash Jessi on 8/2/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.color = UIColor.white
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.placeholder = "Login"
        }
    }
    
    let apiRequest: ApiRequestProtocol = ApiRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        navigationController?.navigationBar.isHidden = true
        activityIndicator.stopAnimating()
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let name = searchBar.text?.lowercased() else { return }
        activityIndicator.startAnimating()
        
        DispatchQueue.global().async {
            self.apiRequest.checkUserName(name: name, completion: { [weak self] result in
                switch result {
                case .success(let user):
                    self?.activityIndicator.stopAnimating()
                    self?.toProfileViewControler(user: ProfileInfo(with: user))
                    self?.searchBarCancelButtonClicked(searchBar)
                case .failure(let error):
                    print("error USER")
                    print(error)
                    self?.showError(error: error as! ApiError) ///НАПИСАТЬ
                }
            })
        }
    }
    
    func showError(error: ApiError) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            var message = ""
            switch error {
            case .noData, .tokenError:
                message = "Something is wrong. Try again later."
            case .underfined:
                message = "You entered the wrong login. Try again."
            }
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func toProfileViewControler(user: ProfileInfo) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        profileViewController.profileInfo = user
        
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
    }
}

