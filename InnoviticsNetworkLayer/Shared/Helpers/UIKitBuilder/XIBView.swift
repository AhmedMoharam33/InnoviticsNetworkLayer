//
//  XIBView.swift
//  RubikalUIComponents
//
//  Created by ahmed moharam on 24/03/2024.
//

import UIKit

open class XIBView: UIView {
    
    public init() {
        super.init(frame: .zero)
        loadSelfFromNib()
        setup()
    }
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        loadSelfFromNib()
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadSelfFromNib()
        setup()
    }
    
    open func setup() { }
}
