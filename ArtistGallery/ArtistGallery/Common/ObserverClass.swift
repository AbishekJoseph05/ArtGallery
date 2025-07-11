//
//  ObserverClass.swift
//  ArtistGallery
//
//  Created by KaHa on 11/07/25.
//

class Observable<T> {
    
    private var valueChanged: ((T)-> Void)?
    
    var value: T {
        didSet {
            valueChanged?(value)
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    func bind(_ lister: @escaping (T) -> Void){
        lister(value)
        valueChanged = lister
    }
}
