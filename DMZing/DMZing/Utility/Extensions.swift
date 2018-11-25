//
//  Extensions.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
import Kingfisher

/*---------------------NSObject---------------------------*/
extension NSObject {
    static var reuseIdentifier:String {
        return String(describing:self)
    }
}



/*---------------------UIViewController---------------------------*/


//화면 이동
extension UIViewController {
    
    //백버튼
    func setBackBtn(color : UIColor? = UIColor.FlatColor.Blue.deepBlue){
        let backBTN = UIBarButtonItem(image: UIImage(named: "back_white_btn"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(self.pop))
        navigationItem.leftBarButtonItem = backBTN
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    func setupNavBarColor(color : UIColor){
        navigationController?.navigationBar.barTintColor = color
    }
    
    func setLogoButton(){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 118, height: 26)
        menuBtn.setImage(#imageLiteral(resourceName: "dmzing_logo_img"), for: .normal)
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 118)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 26)
        currHeight?.isActive = true
        self.navigationItem.leftBarButtonItem = menuBarItem
    }
    
    func setChatButton(){
        let walkDIcon = UIBarButtonItem(image: UIImage(named: "walk_d_icon"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(self.toChatbotView))
        navigationItem.rightBarButtonItem = walkDIcon
        navigationItem.rightBarButtonItem?.tintColor = UIColor.FlatColor.Blue.deepBlue
        
    }
    
    @objc func toChatbotView(){
        let chatbotVC = UIStoryboard(name: "Chatbot", bundle: nil)
        if let chatbotVC = chatbotVC.instantiateViewController(withIdentifier:ChatbotVC.reuseIdentifier) as? ChatbotVC {
             self.present(chatbotVC, animated: true, completion: nil)
        }
    }
}

extension UIViewController {
    
    func setImgWithKF(url : String, imgView : UIImageView, defaultImg : UIImage){
        if let url = URL(string: url){
            imgView.kf.setImage(with: url)
            
        } else {
            imgView.image = defaultImg
        }
    }
    func gsno(_ value : String?) -> String{
        return value ?? ""
    }
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }
    
    func simpleAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okTitle = "확인"
        let okAction = UIAlertAction(title: okTitle,style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func networkSimpleAlert(){
        let title = "오류"
        let message = "네트워크 연결상태를 확인해주세요"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okTitle = "확인"
        let okAction = UIAlertAction(title: okTitle,style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func simpleAlertwithHandler(title: String, message: String,  isCancleBtnExist : Bool = true, okHandler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okTitle = "확인"
        let okAction = UIAlertAction(title: okTitle,style: .default, handler: okHandler)
        alert.addAction(okAction)
        if isCancleBtnExist {
            let cancelTitle = "취소"
             let cancelAction = UIAlertAction(title: cancelTitle,style: .cancel, handler: nil)
             alert.addAction(cancelAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func addChildView(containerView : UIView, asChildViewController viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    func removeChildView(containerView : UIView, asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func customBarbuttonItem(title : String, red : Double, green : Double, blue : Double, fontSize : Int, selector : Selector?)->UIBarButtonItem{
        let customBarbuttonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
        let fontSize = UIFont.systemFont(ofSize: CGFloat(fontSize))
        customBarbuttonItem.setTitleTextAttributes([
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): fontSize,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(1.0) )
            ], for: UIControlState.normal)
        return customBarbuttonItem
    }
    
}

/*---------------------UIView---------------------------*/

extension UIView {
    func makeRounded(cornerRadius : CGFloat?){
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            self.layer.cornerRadius = self.layer.frame.height/2
        }
        self.layer.masksToBounds = true
    }
    
    func makeViewBorder(width : Double, color : UIColor){
        self.layer.borderWidth = CGFloat(width)
        self.layer.borderColor = color.cgColor
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func shake() {
        self.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
}


/*---------------------UIButton---------------------------*/
extension UIButton{
    func setImage(selected : UIImage, unselected : UIImage){
        self.setImage(selected, for: .selected)
        self.setImage(unselected, for: .normal)
    }
}

/*---------------------UIBarButtonItem---------------------------*/
extension UIBarButtonItem {
    class func itemWith(colorfulImage: UIImage?, target: AnyObject, action: Selector?) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 48).isActive = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        if let action_ = action {
            button.addTarget(target, action: action_, for: .touchUpInside)
            
        }
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
    
    class func titleBarbutton(title : String, red : Double, green : Double, blue : Double, fontSize : CGFloat, fontName : String, selector : Selector?, target: AnyObject)->UIBarButtonItem{
        let customBarbuttonItem = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        let customFont = UIFont(name: fontName, size: fontSize)!
        customBarbuttonItem.setTitleTextAttributes([
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): customFont,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(1.0) )
            ], for: UIControlState.normal)
        customBarbuttonItem.setTitleTextAttributes([
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): customFont,
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(1.0) )
            ], for: UIControlState.selected)
        
        return customBarbuttonItem
    }
}

/*---------------------UICollectionViewCell---------------------------*/
extension UICollectionViewCell {
    func makeCornerRound(cornerRadius : CGFloat){
        self.contentView.layer.cornerRadius = cornerRadius
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
    }
    
    func makeCellCornerRound(corners: UIRectCorner,cornerRadius : CGFloat){
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        //self.layer.cornerRadius = cornerRadius
    }
    
    
}

extension UIImageView {
    func setImgWithKF(url : String, defaultImg : UIImage){
        if let url = URL(string: url){
            self.kf.setImage(with: url)
        } else {
            self.image = defaultImg
        }
    }
}


extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}


/*---------------------CALayer---------------------------*/
extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 0,
        blur: CGFloat = 4,
        spread: CGFloat = 0,
        shadowRadius_ : CGFloat? = 4
        )
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        //원래는 이거였음 shadowRadius = blur / 2.0
        shadowRadius = shadowRadius_ ?? blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}


extension Int{
    func timeStampToDate(dateFormat : String = "yyyy-MM-dd") -> String{
        let unixTimestamp = (self)
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "KST") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateFormat //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
