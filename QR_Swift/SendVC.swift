//
//  SendVC.swift
//  QR_Swift
//
//  Created by Максим Атюцкий on 22.05.2018.
//  Copyright © 2018 Максим Атюцкий. All rights reserved.
//

import UIKit
import AVFoundation

class SendVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var statusField: UILabel!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var userID: String?
    var amount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
 
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            view.bringSubview(toFront: statusField)
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.red.cgColor
                qrCodeFrameView.layer.borderWidth = 3
                
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
        } catch {
            print(error)
            return
        }
    }
    
    func parseData(str: String!) -> [String: String]? {
        var answer = [String: String]()
        
        let parameters = str!.split(separator: ";")
        for parameter in parameters {
            let el = parameter.split(separator: "=")
            if el.count == 2 {
                answer[String(el[0])] = String(el[1])
            }
        }
        if answer.count == 0 {
            return nil
        }
        return answer
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            statusField.text = "Your QR code does not exist"
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        let barCodeObj = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        qrCodeFrameView?.frame = barCodeObj!.bounds
        
        if metadataObj.stringValue != nil {
            let params: [String: String]? = parseData(str: metadataObj.stringValue)
            if params != nil {
                self.captureSession?.stopRunning()
                qrCodeFrameView?.frame = barCodeObj!.bounds
                if params?.count == 1 {
                    statusField.text = "ID: " + params!["id"]!
                    self.userID = params!["id"]!
                    self.amount = nil
                } else if params?.count == 2 {
                    statusField.text = "ID: " + params!["id"]! + " AMOUNT: " + params!["amount"]!
                    self.userID = params!["id"]!
                    self.amount = params!["amount"]!
                }
            } else {
                qrCodeFrameView?.frame = CGRect.zero
                statusField.text = "Your QR code does not exist"
                return
            }
        }
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
