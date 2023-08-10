//
//  GenericTutorialViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 06/08/23.
//

import UIKit

class GenericTutorialViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var gifShadowView: UIView!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gifWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var gifHeightConstraint: NSLayoutConstraint!
    var gifHeightValue: Double?
    @IBOutlet weak var containerView: UIView!
    
    var model: TutorialPageModel?{
        didSet{
            configureModel()
        }
    }
    var tutTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gifHeightValue = self.view.frame.height * gifHeightConstraint.multiplier
        configureGif()
        
        gifImageView.clipsToBounds = true
        gifImageView.layer.cornerRadius = 30
        gifShadowView.dropShadow(shadowType: .tutorialGifShadow)
        gifShadowView.layer.cornerRadius = 30
    }
    
    //MARK: - Configuration
    private func configureModel(){
        guard let model = self.model else { return }
        configureContainerView(items: model.stackContent)
        if let titleLabel = titleLabel{
            titleLabel.text = tutTitle
        }
    }
    
    private func configureGif(){
        guard let model = self.model, let gifHeightValue = gifHeightValue else { return }
        if let gifImageView = gifImageView{
            if let image = UIImage.gifImageWithName(model.gifPath){
                let aspR = image.getAspectRatio()
                gifWidthConstraint.constant = (gifHeightValue / aspR)
                gifImageView.image = image
            }
        }
    }
    
    private func configureContainerView(items: [StackContentItem]){
        guard let containerView = containerView else { return }
        
        if items.count < 3{
            gifHeightValue = self.view.frame.height * 0.55
            let newC = gifHeightConstraint.constraintWithMultiplier(0.55)
            gifHeightConstraint.isActive = false
            newC.isActive = true
            gifShadowView.layoutIfNeeded()
            gifHeightConstraint = newC
            configureGif()
        }
        
        let middleView = UIView()
        var lastView: UIView?
        var i = -1
        
        for item in items {
            i = i + 1
            var newV: UIView?
            switch item.type{
            case .text:
                newV = configureText(text: item.content)
            case .image:
                newV = configureImage(imagePath: item.content, size: CGSize(width: 35, height: 35))
            }
            
            guard let newV = newV else { return }
            if lastView == nil{
                lastView = newV
                newV.translatesAutoresizingMaskIntoConstraints = false
                middleView.addSubview(newV)
                newV.topAnchor.constraint(equalTo: middleView.topAnchor).isActive = true
                newV.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 0).isActive = true
                newV.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: 0).isActive = true
            }else if i == items.count - 1{
                newV.translatesAutoresizingMaskIntoConstraints = false
                middleView.addSubview(newV)
                newV.topAnchor.constraint(equalTo: lastView!.bottomAnchor).isActive = true
                newV.bottomAnchor.constraint(equalTo: middleView.bottomAnchor).isActive = true
                newV.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 0).isActive = true
                newV.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: 0).isActive = true
                lastView = newV
            }else{
                newV.translatesAutoresizingMaskIntoConstraints = false
                middleView.addSubview(newV)
                newV.topAnchor.constraint(equalTo: lastView!.bottomAnchor).isActive = true
                newV.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 0).isActive = true
                newV.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: 0).isActive = true
                lastView = newV
            }
        }
        
        containerView.addSubview(middleView)
        middleView.translatesAutoresizingMaskIntoConstraints = false
        middleView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        middleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        middleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    private func configureImage(imagePath: String, size: CGSize? = nil) -> UIView{
        let imageView = UIImageView()
        imageView.image = UIImage(named: imagePath)?.withTintColor(.componentColor)
        imageView.contentMode = .scaleAspectFit
        if let size = size{
            imageView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        return imageView
    }
    
    private func configureText(text: String) -> UIView{
        let label = UILabel()
        label.text = text
        label.font = UIFont.customFont(.normal, size: 21)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        
        let view = UIView()
        let cView = UIView()
        cView.enableComponentButtonMode()
        cView.layer.cornerRadius = 10
        view.addSubview(cView)
        cView.addSubview(label)
        
        cView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 0).isActive = true
        cView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 0).isActive = true
        cView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        cView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
        label.topAnchor.constraint(equalTo: cView.topAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: cView.bottomAnchor, constant: -10).isActive = true
        label.trailingAnchor.constraint(equalTo: cView.trailingAnchor, constant: -20).isActive = true
        label.leadingAnchor.constraint(equalTo: cView.leadingAnchor, constant: 20).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        cView.translatesAutoresizingMaskIntoConstraints = false
        
        let shadowView = UIView()
        shadowView.addSubview(view)
        view.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor).isActive = true
        
        shadowView.layer.cornerRadius = 7
        shadowView.dropShadow(shadowType: .tutorialGifShadow)
        
        return shadowView
    }

}
