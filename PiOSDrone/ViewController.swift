//
//  ViewController.swift
//  PiOSDrone
//
//  Created by Irakli Tchitadze on 8/14/17.
//  Copyright © 2017 Irakli Tchitadze. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider! {
    	didSet{
    		slider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
    	}
    }
    
    var globalThrottleValue: Int = 0;

    @IBOutlet weak var throttle: UILabel!
    
    let socket = SocketIOClient(socketURL: URL(string: "http://192.168.1.2:3000")!, config: [.log(true), .compress]);

    override func viewDidLoad() {
        super.viewDidLoad()
        connect()
        sendMessage(value: "Hello Socket.IO!!!")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func throttleChanged(_ sender: UISlider) {
        let throttleVal = Int(self.slider.value)
        if globalThrottleValue != throttleVal {
            globalThrottleValue = throttleVal
            throttle.text = String(throttleVal)
            sendMessage(value: String(throttleVal))
        }
    }
    
    func connect() {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.connect()
    }
    
    func sendMessage(value: String) {
        socket.emit("data", value)
    }
}

