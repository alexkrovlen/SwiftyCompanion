//
//  ProfileViewController.swift
//  SwiftyCompanion
//
//  Created by Flash Jessi on 9/12/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var profileInfo: ProfileInfo?
    var projects: [ProjectsUsers]?
    var achievements: [Achievements]?
    var skills: [Skills]?
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var loginProfile: UILabel!
    
    @IBOutlet weak var walletValue: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var evaluationPointsValue: UILabel!
    @IBOutlet weak var evaluationPointsLabel: UILabel!
    @IBOutlet weak var gradeValue: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var avaiLabel: UILabel!
    @IBOutlet weak var avaiValue: UILabel!
    @IBOutlet weak var levelValue: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cursusLabel: UILabel!
    @IBOutlet weak var cursusButton: UIButton!
    
    @IBOutlet weak var tableCursus: UITableView!
    @IBOutlet weak var tableGlobal: UITableView!
    
    
    init(with profileInfo: ProfileInfo) {
        self.profileInfo = profileInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        self.view.isUserInteractionEnabled =  true
        settingBackBar()
        guard let user = profileInfo?.user else {
            print("oops 1")
            return
        }
        projects = profileInfo?.getProjects(user: user, cursus: user.cursusUsers.first?.id ?? 9999)
        achievements = profileInfo?.user.achievements
        skills = profileInfo?.getSkills(user: user, cursus: user.cursusUsers.first?.id ?? 9999)
        
        tableCursus.delegate = self
        tableCursus.dataSource = self
        
        tableGlobal.delegate = self
        tableGlobal.dataSource = self
        
        loadProfileView()
    }
    
    func loadProfileView() {
        self.profileView.backgroundColor = .clear
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        
        self.nameProfile.text = profileInfo?.user.fullName
        self.nameProfile.textColor = .white
        self.nameProfile.font = UIFont.boldSystemFont(ofSize: 30)
        
        self.loginProfile.text = profileInfo?.titleUser(user: profileInfo?.user) ?? profileInfo?.user.login
        self.loginProfile.textColor = .white
        self.loginProfile.font = UIFont.systemFont(ofSize: 18)
        
        self.tableGlobal.backgroundColor = .clear
        self.tableCursus.backgroundColor = .clear
        self.tableCursus.isHidden =  true
        
        self.walletLabel.textColor = UIColor(red: 0 / 255, green: 186 / 255, blue: 188 / 255, alpha: 1)
        self.evaluationPointsLabel.textColor = UIColor(red: 0 / 255, green: 186 / 255, blue: 188 / 255, alpha: 1)
        self.gradeLabel.textColor = UIColor(red: 0 / 255, green: 186 / 255, blue: 188 / 255, alpha: 1)
        self.cursusLabel.textColor = UIColor(red: 0 / 255, green: 186 / 255, blue: 188 / 255, alpha: 1)
        self.progressView.progressTintColor = UIColor(red: 0 / 255, green: 186 / 255, blue: 188 / 255, alpha: 1)
        
        self.cursusButton.setTitle(profileInfo?.user.cursusUsers.first?.name, for: .normal)
        self.gradeValue.text = profileInfo?.user.cursusUsers.first?.grade ?? "Novice"
        self.evaluationPointsValue.text = "\(profileInfo?.user.evaluationPoint ?? 0)"
        self.walletValue.text = "\(profileInfo?.user.wallet ?? 0) \u{20B3}"
        self.avaiLabel.text = profileInfo?.user.location == nil ? "Unavailable" : "Availabel"
        self.avaiValue.text = profileInfo?.user.location ?? "-"
        let level = profileInfo?.user.cursusUsers.first?.level ?? 0.0
        var arrayLevel = String(level).components(separatedBy: ".")
        if arrayLevel[1].count == 1 && arrayLevel[1] != "0" {
            arrayLevel[1] = arrayLevel[1] + "0"
        }
        self.levelValue.text = "level \(arrayLevel[0]) - \(arrayLevel[1])%"
        self.progressView.progress = level - Float(Int(level))
    }
    
    private func settingBackBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 32 / 255, green: 32 / 255, blue: 69 / 255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        let backBarItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarItem
        
    }
    @IBAction func tapCursus(_ sender: Any) {
        tableCursus.isHidden = !tableCursus.isHidden
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var heightHeaderSection = 0
        switch tableView {
        case tableGlobal:
            heightHeaderSection = 44
        case tableCursus:
            heightHeaderSection = 0
        default:
            print("some things wrong 0")
        }
        return CGFloat(heightHeaderSection)
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 0
        switch tableView {
        case tableGlobal:
            numberOfSections =  3
        case tableCursus:
            numberOfSections = 1
        default:
            print("some things wrong 2")
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleOfSections = "null"
        switch tableView {
        case tableGlobal:
            switch section {
            case 0:
                titleOfSections = "Projects"
            case 2:
                titleOfSections = "Achievements"
            case 1:
                titleOfSections = "Skills"
            default:
                break
            }
        case tableCursus:
            titleOfSections = "nillllll"
        default:
            print("some things wrong 3")
        }
        return titleOfSections
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        switch tableView {
        case tableGlobal:
            view.tintColor = UIColor(red: 45 / 255, green: 49 / 255, blue: 82 / 255, alpha: 1)
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.textColor = UIColor.white
            header.textLabel?.textAlignment = .center
            header.textLabel?.font = .preferredFont(forTextStyle: .headline)
            header.textLabel?.font = header.textLabel?.font.withSize(25)
        case tableCursus:
            tableCursus.backgroundView?.backgroundColor = .white
        default:
            print("some things wrong 3")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case tableGlobal:
            switch section {
            case 0:
                numberOfRow = projects!.count
            case 2:
                numberOfRow = achievements!.count
            case 1:
                numberOfRow = skills!.count
            default:
                break
            }
        case tableCursus:
            numberOfRow = profileInfo?.user.cursusUsers.count ?? 1
        default:
            print("some things wrong 4")
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var cellGlobal = CustomViewCell()
        var cellCursus = CursusViewCell()
        switch tableView {
        case tableGlobal:
            cellGlobal = tableGlobal.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomViewCell
            switch indexPath.section {
            case 0:
                cellGlobal.nameLabel.text = projects![indexPath.row].project.name
                if let valid = projects![indexPath.row].validated  {
                    let mark = projects![indexPath.row].finalMark!
                    if valid {
                        cellGlobal.valueLabel.textColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
                        cellGlobal.valueLabel.text = "\u{1F5F8} \(mark)"
                    } else {
                        cellGlobal.valueLabel.textColor = #colorLiteral(red: 1, green: 0.2591518164, blue: 0.1368162334, alpha: 1)
                        cellGlobal.valueLabel.text = "\u{2717} \(mark)"
                    }
                } else {
                    cellGlobal.valueLabel.textColor = #colorLiteral(red: 1, green: 0.4693228006, blue: 0.4593679905, alpha: 1)
                    cellGlobal.valueLabel.text = "\u{2B6F}"
                }
                cellGlobal.heightDescription.constant = CGFloat(0)
                cellGlobal.descriptionLabel.text = ""
            case 2:
                cellGlobal.nameLabel.text = achievements![indexPath.row].name
                cellGlobal.valueLabel.text = ""
                cellGlobal.heightDescription.constant = CGFloat(20)
                cellGlobal.descriptionLabel.text = achievements![indexPath.row].description
            case 1:
                cellGlobal.nameLabel.text = skills![indexPath.row].name
                cellGlobal.valueLabel.textColor = .white
                cellGlobal.valueLabel.text = "\(Double(Int(skills![indexPath.row].level * 100)) / 100.00)"
                cellGlobal.heightDescription.constant = CGFloat(0)
                cellGlobal.descriptionLabel.text = ""
            default:
                cellGlobal.nameLabel.text = "oops cell"
                
            }
            cellGlobal.backgroundColor = UIColor(white: 1, alpha: 0.1)
            return cellGlobal
        case tableCursus:
            cellCursus =  tableCursus.dequeueReusableCell(withIdentifier: "cursusCell", for: indexPath) as! CursusViewCell
            cellCursus.cursusNameLabel.text = profileInfo?.user.cursusUsers[indexPath.row].name
            cellCursus.backgroundColor = UIColor(white: 1, alpha: 0.1)
            return cellCursus
        default:
            print("some things wrong 5")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case tableCursus:
            tableCursus.isHidden = !tableCursus.isHidden
            cursusButton.setTitle(profileInfo?.user.cursusUsers[indexPath.row].name, for: .normal)
            gradeValue.text = profileInfo?.user.cursusUsers[indexPath.row].grade ?? "Novice"
            let level = profileInfo?.user.cursusUsers[indexPath.row].level ?? 0.0
            var arrayLevel = String(level).components(separatedBy: ".")
            if arrayLevel[1].count == 1 && arrayLevel[1] != "0" {
                arrayLevel[1] = arrayLevel[1] + "0"
            }
            levelValue.text = "level \(arrayLevel[0]) - \(arrayLevel[1])%"
            progressView.progress = level - Float(Int(level))
            guard let user = profileInfo?.user else {
                print("oops 2")
                return
            }
            projects = profileInfo?.getProjects(user: user, cursus: user.cursusUsers[indexPath.row].id)
            skills = profileInfo?.getSkills(user: user, cursus: user.cursusUsers[indexPath.row].id)
            tableGlobal.reloadData()
        default:
            print("some thing wrong 6")
        }
    }
    
}
