//
//  GifDisplayCell.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 16/08/23.
//

import UIKit

protocol GifDisplayCellBtnFavDelegate: AnyObject {
    func btnFavouriteAction(rowNo: Int)
}

class GifDisplayCell: UITableViewCell {
    weak var delegateFavBtn: GifDisplayCellBtnFavDelegate?
    @IBOutlet weak var imgFavourite: UIImageView!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var giImgVw: UIImageView!
    
    
    var gifUrl: String? {
        didSet {
            if let gifUrl = gifUrl {
                self.loadGif(with: gifUrl);
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnFavAction(_ sender: UIButton) {
        if let delegateFavBtn = self.delegateFavBtn {
            delegateFavBtn.btnFavouriteAction(rowNo: btnFavourite.tag);
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadGif(with urlString: String) {
        self.giImgVw.image = nil
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: urlString as String) else {
                return
            }
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.giImgVw.image = UIImage.gif(data: data)
            }
        }
    }
    
}
