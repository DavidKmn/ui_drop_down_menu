//
//  ViewController.swift
//  DropDownMenu
//
//  Created by David on 06/11/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var myButton = DropDownButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        myButton = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        myButton.setTitle("Colors", for: .normal)
        myButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myButton)
        
        myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        myButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        myButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        myButton.dropDownView.dropDownOptions = ["Red","Blue","Green","Yellow","Orange","Gray"]
        
    }

}

protocol DropDownProtocol: class {
    func didSelectFromDropDown(string: String)
}

class DropDownButton: UIButton, DropDownProtocol {
    
    func didSelectFromDropDown(string: String) {
        self.setTitle(string, for: .normal)
        dismissDropDown()
    }
    
    var dropDownView = DropDownView()
    
    var height = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.darkGray
        
        dropDownView = DropDownView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropDownView.delegate = self
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
                
       
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropDownView)
        self.superview?.bringSubview(toFront: dropDownView)
        dropDownView.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dropDownView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dropDownView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        height = dropDownView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isOpen == false {
            
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropDownView.tableView.contentSize.height > 150 {
                 self.height.constant = 150
            } else {
                self.height.constant = self.dropDownView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                    self.dropDownView.layoutIfNeeded()
                    self.dropDownView.center.y += self.dropDownView.frame.height/2
                
            }, completion: nil)
            
        } else if isOpen == true {
            dismissDropDown()
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.dropDownView.center.y -= self.dropDownView.frame.height/2
            self.dropDownView.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView()
    var dropDownOptions = [String]()
    let cellId = "cellId"
    weak var delegate: DropDownProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.backgroundColor = .darkGray
        self.backgroundColor = .darkGray
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.backgroundColor = .darkGray
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let choice = dropDownOptions[indexPath.row]
        delegate?.didSelectFromDropDown(string: choice)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}











