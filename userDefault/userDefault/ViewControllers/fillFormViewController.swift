//
//  fillFormViewController.swift
//  examDemoApp
//
//  Created by iMac on 28/07/22.
//

import UIKit

class fillFormViewController: UIViewController {

    //MARK: OutletDeclare
    @IBOutlet weak var BackGroundView: UIView!
    @IBOutlet weak var ImageUserImage: UIImageView!
    @IBOutlet weak var textEnterFirstName: UITextField!
    @IBOutlet weak var textEnterLastName: UITextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var btnStudentRole: UIButton!
    @IBOutlet weak var btnTutorRole: UIButton!
    @IBOutlet weak var btnSaved: UIButton!
    @IBOutlet weak var lblheight: UILabel!
    
    //MARK: variable Declare
    let imagePicker = UIImagePickerController()
    var role:String?
    var cDateAndtime:String?
    var getDateAndTime:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpInAll()
        setUserImage()
        sliderSetUp()
        print(getDateAndTime)
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidTapped))
        BackGroundView.addGestureRecognizer(tapgesture)
        tapgesture.cancelsTouchesInView = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCurrentDateAndTime()
        self.textEnterFirstName.delegate = self
        self.textEnterLastName.delegate = self
    }
    
    @objc func backgroundViewDidTapped(){
        self.view.endEditing(true)
    }
    
    //MARK: AllView Setup
    func setUpInAll(){
        btnSaved.layer.cornerRadius = 10
        
        ImageUserImage.layer.borderWidth = 1.0
        ImageUserImage.layer.masksToBounds = false
        ImageUserImage.layer.borderColor = UIColor.white.cgColor
        ImageUserImage.makeRound()
        ImageUserImage.clipsToBounds = true
    }
    
    //MARK: Slider Setup
    func sliderSetUp(){
        slider.value = 60
        slider.minimumValue = 0
        slider.maximumValue = 120
        slider.setThumbImage(UIImage(named: "Ellipse"), for: .normal)
//                             (systemName: "Ellipse"), for: .normal)
        lblheight.text = String(Int(slider.value))
        
    }
    
    @IBAction func sliderrAction(_ sender: Any) {
        lblheight.text = String(Int(slider.value))
    }
    
    //MARK: Func Current Date & Time Set
    func setCurrentDateAndTime(){
        
        let today = Date.now
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy • h:mm a"
        self.getDateAndTime = formatter.string(from: today)
//        print(formatter.string(from: today))
    }
    
    //MARK: Func Set user Image
    func setUserImage(){
        let userImageTaped = UITapGestureRecognizer(target: self, action: #selector(userImageSetUp(tapGestureRecognizer:)))
        self.ImageUserImage.addGestureRecognizer(userImageTaped)
    }
    
    @objc func userImageSetUp(tapGestureRecognizer: UITapGestureRecognizer){
        let Alert = UIAlertController.init(title: "Select Image!", message: nil, preferredStyle: .actionSheet)
        let gallary = UIAlertAction.init(title: "Gallary", style: .default){
            UIAlertAction in
            self.openGallary()
        }
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel){
            UIAlertAction in
            self.view.endEditing(true)
        }
        Alert.addAction(gallary)
        Alert.addAction(cancel)
        self.present(Alert, animated: true, completion: nil)
    }
    
    //MARK: Func Open Gallary
    func openGallary(){
        if imagePicker.sourceType == .photoLibrary{
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: Func Button MArk &Unmark
    func setOptionSelected(_ roleSelectedBtn: UIButton){
        btnStudentRole.isSelected = roleSelectedBtn == btnStudentRole
        btnTutorRole.isSelected = roleSelectedBtn == btnTutorRole
    }
    
    @IBAction func btnStudentRoleAction(_ sender: Any) {
        setOptionSelected(btnStudentRole)
    }
    
    @IBAction func btnTutorRoleAction(_ sender: Any) {
        setOptionSelected(btnTutorRole)
    }
    
    //MARK: Button Saved Click Action
    @IBAction func btnSavedAction(_ sender: Any) {
        if textEnterFirstName.text != "",textEnterLastName.text != ""{
            
            if (btnStudentRole.isSelected == false) && (btnTutorRole.isSelected == false) {
                let Alert = UIAlertController.init(title: "Alert", message: "Select Your Role!", preferredStyle: .alert)
                let ok = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
                Alert.addAction(ok)
                self.present(Alert, animated: true, completion: nil)
            }
            
            if btnStudentRole.isSelected == true{
                self.role = "Student"
            }else{
                self.role = "Tutor"
            }
            
            let UserData = userModel(userImage: ImageUserImage.image?.jpegData(compressionQuality: 0.5)!,
                                 firstName: textEnterFirstName.text!,
                                 lastName: textEnterLastName.text!,
                                 userRole: self.role!,
                                 dateAndTime: self.getDateAndTime!)
            
            if let savedData = UserDefaults.standard.object(forKey: "UserData") as? Data {
                let decoder = JSONDecoder()
                if let arrUserNew = try? decoder.decode([userModel].self, from: savedData) {
                    print(arrUserNew)
                    
                    var empArray = arrUserNew
                    empArray.append(UserData)
                    print(empArray)
                    
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(empArray) {
                        UserDefaults.standard.set(encoded, forKey: "UserData")
                    }
                }
            }else {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode([UserData]) {
                    UserDefaults.standard.set(encoded, forKey: "UserData")
                }
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        else if textEnterFirstName.text == "" {
            let Alert = UIAlertController.init(title: "Alert", message: "Enter First Name!", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
            Alert.addAction(ok)
            self.present(Alert, animated: true, completion: nil)
            
        }else if textEnterLastName.text == "" {
            let Alert = UIAlertController.init(title: "Alert", message: "Enter Last Name!", preferredStyle: .alert)
            let ok = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
            Alert.addAction(ok)
            self.present(Alert, animated: true, completion: nil)
        }
    }
}

//MARK: Extension UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension fillFormViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if imagePicker.sourceType == .photoLibrary{
            ImageUserImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        }else{
            ImageUserImage.image = UIImage(named: "user")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: Extension UITextFieldDelegate
extension fillFormViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
