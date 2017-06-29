//
//  SeleccionBalizaPresenter.swift
//  Proyectito
//
//  Created by Loquat Solutions on 26/6/17.
//  Copyright © 2017 MHP. All rights reserved.
//


import Foundation
import UIKit
import CoreBluetooth
protocol SeleccionBalizaView: NSObjectProtocol {
    func setBalizas(balizas: [Baliza])

}



class SeleccionBalizaPresenter: ProtocoloEscaneo, ProtocoloFirmado{
  
    
    
    fileprivate let seleccionBalizaService: SeleccionBalizaService
    weak fileprivate var seleccionBalizaView : SeleccionBalizaView?
    fileprivate var escaneo : Escaneo
    fileprivate var firmado : Firmado
    
    
    
    
    init(seleccionBalizaService: SeleccionBalizaService, escaneo: Escaneo, firmado: Firmado) {
        self.seleccionBalizaService = seleccionBalizaService
        self.escaneo = escaneo
        self.firmado = firmado
    }
    
    func attachView(_ view: SeleccionBalizaView){
        self.seleccionBalizaView = view
    }
    
    func detachView() {
        self.seleccionBalizaView = nil
    }
    
    func obtenerBalizas() {
        self.seleccionBalizaService.obtenerBalizas(callback: { (balizas) in
            self.seleccionBalizaView?.setBalizas(balizas: balizas)
        })
    }
    
    

    
    func escan() {
        self.escaneo.inicializar(presenter: self)
        
    }
    
    
    func perifericoEncontrado(peripheral: CBPeripheral, manager: CBCentralManager)   {
        print("el periferico encontrado y devuelto al presenter es:..")
        if peripheral.identifier.uuidString == "8050E981-A980-4562-9016-883D2FB7FA6A"{
               print("Es el que busco")
               self.firmado.inicializarFirmado(presenter: self, manager: manager, peripheral: peripheral)
            
         }
    
    }
    
    func perifericoFirmado() {
    
       print ("has fichado a las 00:00:000")
    
    
    }
    
    
    


}
