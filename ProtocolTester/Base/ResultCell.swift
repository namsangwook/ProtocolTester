//
//  ResultCell.swift
//  ProtocolTester
//
//  Created by swnam on 2020/07/27.
//  Copyright © 2020 dki. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var method: UILabel!
    @IBOutlet weak var request: UILabel!
    @IBOutlet weak var response: UILabel!
    
    @IBOutlet weak var arrowImgView: UIImageView!
    
    @IBAction func copyBtnClicked(_ sender: Any) {
        UIPasteboard.general.string = response.text
        Toast.showNegativeMessage(message: "Copy to clipboard")
    }
    
    var data: TestCase? {
        didSet {
            if let data = data {
                name.text = data.name
                method.text = data.method.rawValue
                result.text = data.result
                request.text = data.request
                response.text = data.response
                
                
                if data.result == "Log" {
                    name.textColor = UIColor(136, 191, 180)
                    method.textColor = UIColor(136, 191, 180)
                    result.textColor = UIColor(136, 191, 180)
                } else if data.result == "fail" {
                    name.textColor = UIColor(247, 107, 107)
                    method.textColor = UIColor(247, 107, 107)
                    result.textColor = UIColor(247, 107, 107)
                } else {
                    name.textColor = .white
                    method.textColor = .white
                    result.textColor = .white
                }
                
                request.sizeToFit()
                response.sizeToFit()
                setNeedsLayout()
                layoutIfNeeded()
                
            }

        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.textColor = .white
        method.textColor = .white
        result.textColor = .white
        requestCopyBtn?.isHidden = false
        responseCopyBtn?.isHidden = false
    }
    
    var showDetail: Bool = false{
        didSet {
            request.isHidden = !showDetail
            response.isHidden = !showDetail
            arrowImgView.isHighlighted = showDetail
        }
    }
    
    @objc func btnClicked(sender: UIButton) {
        if let label = sender.superview as? UILabel {
            UIPasteboard.general.string = label.text
            Toast.showNegativeMessage(message: "Copy to clipboard")
            sender.isHidden = true
        }

    }
    
    var requestCopyBtn: UIButton?
    var responseCopyBtn: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        request.isUserInteractionEnabled = true
        var button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        button.setTitle("COPY", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
        button.sizeToFit()
        button.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        button.layer.borderWidth = 1

        request.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        requestCopyBtn = button
        
        response.isUserInteractionEnabled = true
        button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.setTitleColor(UIColor(41, 41, 41), for: .normal)
        button.setTitle("COPY", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
        button.sizeToFit()
        button.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor(41, 41, 41).cgColor
        button.layer.borderWidth = 1

        response.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
        responseCopyBtn = button
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
