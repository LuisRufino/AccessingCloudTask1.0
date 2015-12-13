//
//  ViewController.swift
//  AccessingCloudTask1.0
//
//  Created by Luis Rufino Perez Romero on 12/12/15.
//  Copyright © 2015 Luis Rufino Perez Romero. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let URL_String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    @IBOutlet weak var textFieldISBN: UITextField!
    @IBOutlet weak var textViewResult: UITextView!
    @IBOutlet weak var buttonClear: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textFieldISBN.delegate = self
        textFieldISBN.returnKeyType = .Search
        
        textViewResult.layer.cornerRadius = 10
        buttonClear.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearISBN(sender: AnyObject) {
        textViewResult.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let inputISBN = textFieldISBN.text {
            requestISBN(inputISBN)
        }
        textField.resignFirstResponder()
        return true
    }
    
    func requestISBN(ISBN: String) {
        let urlRequest = URL_String + ISBN
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlRequest)
        
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
                dispatch_async(dispatch_get_main_queue(), {
                    self.showErrorAlert(error!.localizedDescription)
                })
            }
            else {
                if let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.textViewResult.text = String(dataString)
                    })
                }
            }
        }
        
        task.resume()
    }
    
    func showErrorAlert(error: String) {
        let alert = UIAlertController(title: "Network Error", message: error, preferredStyle: .Alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        alert.addAction(dismiss)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

