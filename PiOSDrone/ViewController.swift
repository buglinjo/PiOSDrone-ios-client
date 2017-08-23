//
//  ViewController.swift
//  PiOSDrone
//
//  Created by Irakli Tchitadze on 8/14/17.
//  Copyright © 2017 Irakli Tchitadze. All rights reserved.
//

import UIKit
import Starscream

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider! {
    	didSet{
    		slider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
    	}
    }
    
    @IBOutlet weak var connectOrDisconnectButton: UIButton!
    
    var globalThrottleValue: Int = 0;
    
    var status = false;
    
    @IBOutlet weak var statusLabel: UILabel!

    @IBOutlet weak var throttle: UILabel!
    
    
    var socket = WebSocket(url: URL(string: "ws://192.168.4.1:81/")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.delegate = self as? WebSocketDelegate
        
        socket.onConnect = {
            print("websocket is connected")
            self.status = true
            self.statusLabel.text = "Status: Connected"
            self.connectOrDisconnectButton.setTitle("Disconnect", for: .normal)
        }
        
        socket.onDisconnect = { (error: NSError?) in
            print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
            self.status = false
            self.statusLabel.text = "Status: Not Connected"
            self.connectOrDisconnectButton.setTitle("Connect", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectOrDisconnect(_ sender: Any) {
        if !status {
            socket.connect()
        } else {
            socket.disconnect()
        }
    }

    @IBAction func throttleChanged(_ sender: UISlider) {
        let throttleVal = Int(self.slider.value)
        if globalThrottleValue != throttleVal {
            globalThrottleValue = throttleVal
            throttle.text = String(throttleVal)
            socket.write(string: String(throttleVal))
        }
    }
}

