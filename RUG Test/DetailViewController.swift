//
//  DetailViewController.swift
//  RUG Test
//
//  Created by Kinney Kare on 5/15/22.
//

import UIKit

class DetailViewController: UIViewController{
    
    // MARK: - Variable & Contstant Declarations
    weak var delegate: DetailVCDelegate?
    var newFirstName = ""
    var newLastName = ""
    private var isImage = true
    private var rightBarButton = UIBarButtonItem()
    
    private let userImage: UIImageView = {
       
        let userImage = UIImageView()
        userImage.translatesAutoresizingMaskIntoConstraints = false
        return userImage
    }()
    
    var firstName: UITextField = {
        let firstName = UITextField()
        firstName.translatesAutoresizingMaskIntoConstraints = false
        return firstName
    }()
    
    var lastName: UITextField = {
        let lastName = UITextField()
        lastName.translatesAutoresizingMaskIntoConstraints = false
        return lastName
    }()
    
    // MARK: - ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(userImage)
        view.addSubview(firstName)
        view.addSubview(lastName)
        newFirstName = firstName.text!
        newLastName = lastName.text!
        setupViews(_imageView: userImage, firstNameTextField: firstName, lastNameTextField: lastName)
        addConstraints()
    }
    
    // TODO: - I have this same function in two files. I need to put in its own file and reuse it as needed.
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let this = self else { return }
            guard let data = data, error == nil else {
                this.isImage = false
                return
            }
            
            //now we can create the image with this "task"/data
            DispatchQueue.main.async {
                if this.isImage {
                    let image = UIImage(data: data)
                    this.userImage.image = image
                } else {
                    this.userImage.image = UIImage(named: K.ImageAssets.noImage)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - setup views method
    private func setupViews(_imageView: UIImageView, firstNameTextField: UITextField, lastNameTextField: UITextField) {
        
        //setup image
        _imageView.center = view.center
        _imageView.layer.cornerRadius = 100
        _imageView.clipsToBounds = true
        _imageView.layer.borderWidth = 0.01
        _imageView.layer.borderColor = UIColor.systemGray.cgColor
        
        //setup first name
        firstNameTextField.font = .systemFont(ofSize: 20, weight: .bold)
        firstNameTextField.textColor = .systemBlue
        firstNameTextField.textAlignment = .center
        firstNameTextField.backgroundColor = .clear
        firstNameTextField.addTarget(self, action: #selector(firstNameDidChange), for: UIControl.Event.editingChanged)
        
        //setup last name
        lastNameTextField.font = .systemFont(ofSize: 20, weight: .bold)
        lastNameTextField.textColor = .systemBlue
        lastNameTextField.textAlignment = .center
        lastNameTextField.backgroundColor = .clear
        lastNameTextField.addTarget(self, action: #selector(lastNameDidChange), for: UIControl.Event.editingChanged)
    }
    
    // MARK: add constraints method
    private func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(userImage.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(userImage.heightAnchor.constraint(equalToConstant: 200))
        constraints.append(userImage.widthAnchor.constraint(equalToConstant: 200))
        
        constraints.append(firstName.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(firstName.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(firstName.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 5))
        constraints.append(firstName.heightAnchor.constraint(equalToConstant: 30))
        
        constraints.append(lastName.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(lastName.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: 1))
        constraints.append(lastName.heightAnchor.constraint(equalToConstant: 30))
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - VController @objc methods
    @objc func rightBarButtonTapped() {
        //Handle Saved Tapped
        newFirstName = firstName.text ?? "No Name"
        newLastName = lastName.text ?? "No Name"
        delegate?.usernameDidChange(self, to: newFirstName, to: newLastName)
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func firstNameDidChange() {
        textfieldDidChangeLogic(name: firstName, newName: newFirstName)
    }
    
    @objc func lastNameDidChange() {
        textfieldDidChangeLogic(name: lastName, newName: newLastName)
    }
    
    func textfieldDidChangeLogic(name: UITextField, newName: String) {
        if let userName = name.text {
            if userName == newName {
                rightBarButton.isEnabled = false
            } else {
                rightBarButton = UIBarButtonItem(title: K.BarButtonTitle.save, style: .plain, target: self, action: #selector(rightBarButtonTapped))
                self.navigationItem.rightBarButtonItem = rightBarButton
            }
        }
    }
}
