//
//  GetVC.swift
//  QR_Swift
//
//  Created by Максим Атюцкий on 22.05.2018.
//  Copyright © 2018 Максим Атюцкий. All rights reserved.
//

import UIKit
import QRCode

class GetVC: UIViewController {

    @IBOutlet weak var qr: UIImageView!
    @IBOutlet weak var amountField: UITextField!
    
    let userID = 1456
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountField.keyboardType = .decimalPad
    
        setQrCode(id: userID, amount: nil)
    }
    
    func setQrCode(id: Int?, amount: String?) {
        var params: String = ""
        if id != nil {
            params += "id=" + String(id!)
        }
        if amount != nil {
            params += ";amount=" + String(amount!)
        }
        
        let qrCode = QRCode(params)
        qr.image = qrCode?.image
    }
    
    @IBAction func amountFieldEditingChanged(_ sender: Any) {
        self.setQrCode(id: self.userID, amount: amountField.text)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
