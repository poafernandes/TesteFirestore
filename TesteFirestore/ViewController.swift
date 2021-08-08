//
//  ViewController.swift
//  TesteFirestore
//
//  Created by Alexandre on 08/08/21.
//

import FirebaseFirestore
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    let database = Firestore.firestore()
    
    private let label: UILabel = {
        
        let label = UILabel()
        
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let field: UITextField = {
        let field  = UITextField()
        
        field.placeholder = "Escreva o texto a ser salvo..."

        field.layer.borderWidth = 1
        
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(label)
        view.addSubview(field)
        
        field.delegate = self
        
        let docRef = database.document("/firestoreTeste/docTeste")
        
        docRef.addSnapshotListener{ [weak self] snapshot, error in
            guard let data = snapshot?.data(), error  == nil else {
                return
            }
            
            guard let text = data["text"] as? String else {
                return
            }
            
            DispatchQueue.main.async {
                self?.label.text = text
            }
            
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        field.frame = CGRect(x: 10,
                             y: view.safeAreaInsets.top+10,
                             width: view.frame.size.width-20,
                             height: 50)
        
        label.frame = CGRect(x: 10,
                             y: view.safeAreaInsets.top+70,
                             width: view.frame.size.width-20,
                             height: 100)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text, !text.isEmpty {
            writeDataDB(text: text)
        }
        
        return true
    }

    func writeDataDB(text: String) {
        let docRef = database.document("/firestoreTeste/docTeste")
        
        docRef.setData(["text": text])
    }
}

