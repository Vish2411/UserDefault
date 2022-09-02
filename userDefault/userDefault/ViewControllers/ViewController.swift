//
//  ViewController.swift
//  examDemoApp
//
//  Created by iMac on 28/07/22.
//

import UIKit


var userArray = [userModel]()

class ViewController: UIViewController{

    //MARK: Outlet Declare
    @IBOutlet weak var mytableView: UITableView!
    @IBOutlet weak var outSwitch: UISwitch!
    
    //MARK: Variable Declare
    var studentArray = [userModel]()
    var tutorArray = [userModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptableView()
        mytableView.delegate = self
        mytableView.dataSource = self
        outSwitch.isOn = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        outSwitch.isOn = false
        ObservDataFromUSerDefault()
    }
    
    //MARK: Func ObservDataFromUSerDefault
    func ObservDataFromUSerDefault(){
        
        if let savedData = UserDefaults.standard.object(forKey: "UserData") as? Data {
            let decoder = JSONDecoder()
            if let arrUserNew = try? decoder.decode([userModel].self, from: savedData) {
                print(arrUserNew)
                
                userArray = arrUserNew
                
                if outSwitch.isOn == false{
                    self.tutorArray = userArray.filter { model in
                        return model.userRole == "Tutor"
                    }
                }
                mytableView.reloadData()
            }
        }
    }

    @IBAction func switchAction(_ sender: Any) {
        if outSwitch.isOn{
            studentArray.removeAll()
            studentArray = userArray.filter { model in
                return model.userRole == "Student"
//                return (model.userRole ?? "") == "Student"
            }
        }
        mytableView.reloadData()
    }
    
    @IBAction func btnAdddataAction(_ sender: Any) {
        let form = self.storyboard?.instantiateViewController(withIdentifier: "fillFormViewController") as! fillFormViewController
        self.navigationController?.pushViewController(form, animated: true)
    }
}

//MARK: Extension UITableViewDelegate,UITableViewDataSource
extension ViewController : UITableViewDelegate,UITableViewDataSource{
    
    private func setuptableView(){
        mytableView.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "TableCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if outSwitch.isOn{
            return studentArray.count
        }else{
            return tutorArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mytableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TableCell else{
            return.init()}
        
        cell.backView.layer.cornerRadius = 10
        
        cell.profileImage.layer.borderWidth = 1.0
        cell.profileImage.layer.masksToBounds = false
        cell.profileImage.layer.borderColor = UIColor.white.cgColor
        //cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2
        cell.profileImage.makeRound()
        cell.profileImage.clipsToBounds = true
        
        if outSwitch.isOn{
            cell.lblFullName.text = "\(studentArray[indexPath.row].firstName!)" + " \(studentArray[indexPath.row].lastName!)"
            cell.lblRole.text = studentArray[indexPath.row].userRole
            cell.lblSystemDate.text = studentArray[indexPath.row].dateAndTime
            if let loadedImage:UIImage = UIImage(data: (studentArray[indexPath.row].userImage!)) {
                cell.profileImage.image = loadedImage
            }
        }else{
            cell.lblFullName.text = "\(tutorArray[indexPath.row].firstName!)" + " \(tutorArray[indexPath.row].lastName!)"
            cell.lblRole.text = tutorArray[indexPath.row].userRole
            cell.lblSystemDate.text = tutorArray[indexPath.row].dateAndTime
            if let loadedImage:UIImage = UIImage(data: (tutorArray[indexPath.row].userImage!)) {
                cell.profileImage.image = loadedImage
            }
        }
        return cell
    }
    
    
}

extension UIView{
    
    func makeRound(){
        self.layer.cornerRadius = self.frame.size.width/2
    }
}
