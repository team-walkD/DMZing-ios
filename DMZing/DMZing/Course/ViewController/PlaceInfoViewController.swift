//
//  PlaceInfoViewController.swift
//  DMZing
//
//  Created by 김예은 on 11/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit
import Kingfisher

class PlaceInfoViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var closedLabel: UILabel!
    @IBOutlet weak var parkingLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var navi: UINavigationBar!
    
    var cid: Int = 0
    var num: String = ""
    var content: String = ""
    var restDay: String = ""
    var parking: String = ""
    var infoCenter: String = ""
    var imageUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        backView.makeRounded(cornerRadius: 10)
        backView.dropShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 0.3, offSet: CGSize(width: -0.5, height: 0.5), radius: 10, scale: true)
        
        numberLabel.text = "0\(num)"
        
        let attr = try? NSAttributedString(htmlString: content, font: UIFont(name: "AppleSDGothicNeo-Regular", size: 16))
        contentTextView.attributedText = attr
        
        
        closedLabel.text = restDay
        parkingLabel.text = parking
        phoneLabel.text = infoCenter
        backImageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage())
        
        closedLabel.adjustsFontSizeToFitWidth = true
        parkingLabel.adjustsFontSizeToFitWidth = true
        phoneLabel.adjustsFontSizeToFitWidth = true

    }
    
    //MARK: navigationBar transparent
    func setNavigationBar() {
        
        navi.isTranslucent = true
        navi.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navi.shadowImage = UIImage()
        navi.backgroundColor = UIColor.clear
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension String {
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "color: #\(color.cgColor) !important;" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

//MARK: - HTML extension
extension NSAttributedString {
    
    convenience init(htmlString html: String, font: UIFont? = nil, useDocumentFontSize: Bool = true) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontFamily = font?.familyName, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
          
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }
        
        let fontSize: CGFloat? = useDocumentFontSize ? nil : font!.pointSize
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)
                
                if (traits.rawValue & UIFontDescriptorSymbolicTraits.traitBold.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitBold)!
                }
                
                if (traits.rawValue & UIFontDescriptorSymbolicTraits.traitItalic.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitItalic)!
                }
            
               attr.addAttribute(.foregroundColor, value: UIColor.FlatColor.Blue.deepBlue, range: NSRange(location: 0, length: attr.length))

                attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize), range: range)
            }
        }
        
        self.init(attributedString: attr)
    }
    
}

//MARK: - UIView Shadow extension
extension UIView {

    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
