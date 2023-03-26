//
//  GradientView.swift
//  EngWord
//
//  Created by hieu nguyen on 09/03/2023.
//

import UIKit

class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    override func draw(_ rect: CGRect) {
        // 1
        let components: [CGFloat] = [ 0, 0, 0, 0.3, 0, 0, 0, 0.7 ]
        let locations: [CGFloat] = [ 0, 1 ]
        // 2
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace,
                                  colorComponents: components,
                                  // 3
                                  locations: locations, count: 2)
        let xxxx = bounds.midX
        let yyyy = bounds.midY
        let centerPoint = CGPoint(x: xxxx, y: yyyy)
        let radius = max(xxxx, yyyy)
        // 4
        let context = UIGraphicsGetCurrentContext()
        context?.drawRadialGradient(gradient!,
                                    startCenter: centerPoint, startRadius: 0,
                                    endCenter: centerPoint, endRadius: radius,
                                    options: .drawsAfterEndLocation)
    }
}
