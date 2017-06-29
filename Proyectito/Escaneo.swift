//
//  Escaneo.swift
//  Proyectito
//
//  Created by Loquat Solutions on 28/6/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import Foundation
import CoreBluetooth
protocol ProtocoloEscaneo{
    func perifericoEncontrado(peripheral:CBPeripheral ,manager:CBCentralManager)
}

class Escaneo: NSObject {
    
    

    var manager: CBCentralManager!
    var peripheral:CBPeripheral!
    
    var presenter: SeleccionBalizaPresenter!
    
    
    func inicializar(presenter: SeleccionBalizaPresenter) {
        self.presenter = presenter
        manager = CBCentralManager (delegate: self, queue: nil)
        
    }
    
    
}




extension Escaneo: CBCentralManagerDelegate {
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn{
            central.scanForPeripherals(withServices: nil, options: nil)
            print ("habilitado")
            print(central.isScanning)
            
        }else{
            print ("no está habilitado.")
        }
    }
    
    
    
    func perifericoEncontrado(callback:@escaping (CBPeripheral) -> ())  -> Void  {
        callback(self.peripheral)
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("lkaj")
        print (peripheral)
        peripheral.maximumWriteValueLength(for: CBCharacteristicWriteType(rawValue: 50)!)
        self.manager.stopScan()
        self.presenter.perifericoEncontrado(peripheral: peripheral,manager: manager)
        
        
        /*
        
        if peripheral.identifier.uuidString == "8050E981-A980-4562-9016-883D2FB7FA6A"{
            
            //  DDEBE7A9-F336-4D8A-A406-E7F6666AE1BE
            print("Did discover peripheral", peripheral.identifier)
         
            
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager.connect(peripheral, options: nil)*/
        
        
        
    }
    
    
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    
    
}



extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}


