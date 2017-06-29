//
//  Firmado.swift
//  Proyectito
//
//  Created by Loquat Solutions on 28/6/17.
//  Copyright © 2017 MHP. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol ProtocoloFirmado {
    func perifericoFirmado ()
}

class Firmado: NSObject  {

    var manager: CBCentralManager!
    var peripheral:CBPeripheral!
    var presenter: SeleccionBalizaPresenter!
    
    
    
    func inicializarFirmado(presenter: SeleccionBalizaPresenter, manager: CBCentralManager, peripheral: CBPeripheral) {
        self.presenter = presenter
        self.manager = manager
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        manager.connect(peripheral, options: nil)
        
        
        
    }
    
    func systemUptime() -> TimeInterval {
        
        
        var currentTime = time_t()
        var bootTime    = timeval()
        var mib         = [CTL_KERN, KERN_BOOTTIME]
        
        var size = MemoryLayout<timeval>.stride
        let result = sysctl(&mib, u_int(mib.count), &bootTime, &size, nil, 0)
        if result != 0 {
            #if DEBUG
                print("ERROR - \(#file):\(#function) - errno = "
                    + "\(result)")
            #endif
            
            return 0
        }
        
        time(&currentTime)
        let uptime = currentTime - bootTime.tv_sec
        
        return TimeInterval(uptime)
    }
    
    


}




extension Firmado:  CBPeripheralDelegate {
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            print ("este es el servicio",thisService.uuid.uuidString)
            if service.uuid.uuidString == "0000F00D-1212-EFDE-1523-785FEF13D123" {
                peripheral.discoverCharacteristics(
                    nil,
                    for: thisService
                )
                
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        print("Looping through characteristics")
        if let charactericsArr = service.characteristics{
            for charactericsx in charactericsArr
            {
                peripheral.maximumWriteValueLength(for: CBCharacteristicWriteType(rawValue: 50)!)
                print("esta es la caracteristica:",charactericsx)
                peripheral.setNotifyValue(true, for: charactericsx)
                
                //Aaaeee
                let comando : [UInt8] = [ 52]
                let prueba : [UInt8] = [ 33, 34, 35, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34  ]
                //print ("uuuu", fraccionDatagrama(datagrama: prueba))
                print ("llllll",prueba[1...3])
                // fraccionDatagrama(datagrama: prueba)
                let buf = [UInt8](Date().currentUTCTimeZoneDate.utf8)
                
                
                
                let bytes = comando + buf + prueba
                
                let data2 = Data(bytes:bytes)
                // let data3 = Data(bytes:prueba)
                
                print (bytes)
                print (buf)
                
                
                peripheral.writeValue(data2, for: charactericsx,type: CBCharacteristicWriteType.withResponse)
                
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if var _ :NSData = characteristic.value as NSData? {
            peripheral.readValue(for: characteristic)
            
            print (characteristic)
            manager.cancelPeripheralConnection(peripheral)
            
            print("este es el uptime ",self.systemUptime())
            
            print("UTC",Date().currentUTCTimeZoneDate)
            
            
            let buf = [UInt8](Date().currentUTCTimeZoneDate.utf8)
            for value in buf {
                print (value)
            }
            presenter.perifericoFirmado()
            
            // let n = 123
            //var st = String(format:"%2X", n)
            //st += " is the hexadecimal representation of \(n)"
            // "7B is the hexadecimal representation of 123"
            
            
            print(buf)
        }
    }
}


extension Date {
    
    
    var currentUTCTimeZoneDate: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: self)
    }
}



