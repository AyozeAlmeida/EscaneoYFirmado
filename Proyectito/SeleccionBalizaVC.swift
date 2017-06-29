//
//  ViewController.swift
//  Proyectito
//
//  Created by Loquat Solutions on 26/6/17.
//  Copyright © 2017 MHP. All rights reserved.
//


import UIKit


class SeleccionBalizaVC: UIViewController {
    
    @IBOutlet weak var buscador: UISearchBar!
    @IBOutlet weak var collectionBalizas: UICollectionView!
    
    fileprivate let seleccionBalizaPresenter =
        SeleccionBalizaPresenter(seleccionBalizaService: SeleccionBalizaService(), escaneo: Escaneo(), firmado: Firmado())
    
    var listaBalizas : [Baliza] = []
    var listaBalizasFiltro : [Baliza] = []
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       // self.inicializarVista()
        self.collectionBalizas.dataSource = self
        
        
       // self.buscador.delegate = self
        self.seleccionBalizaPresenter.attachView(self)
       // self.seleccionBalizaPresenter.obtenerBalizas()
        
        self.seleccionBalizaPresenter.escan()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func inicializarVista() {
        self.buscador.placeholder = NSLocalizedString("Buscar baliza", comment: "Buscar balizas") + "..."
    }
    
}

extension SeleccionBalizaVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaBalizas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let baliza: Baliza = self.listaBalizas[indexPath.row]
        
        let celdaBaliza = collectionView.dequeueReusableCell (withReuseIdentifier: "SeleccionBalizaCell", for: indexPath)
            as! SeleccionBalizaCell
        
        celdaBaliza.backgroundColor = UIColor.red
        
        celdaBaliza.uuidLabel.text = baliza.uuid
        
        
        return celdaBaliza
    }
}


extension SeleccionBalizaVC: SeleccionBalizaView {
    
    
    func setBalizas(balizas: [Baliza]) {
        self.listaBalizas = balizas
        // self.seleccionBalizaPresenter.filtrarBalizas(listaBalizas: self.listaBalizas, texto: buscador.text!)
    }
    
}











