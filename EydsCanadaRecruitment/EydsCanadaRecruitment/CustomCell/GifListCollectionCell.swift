//
//  GifListCollectionCell.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 17/08/23.
//

import UIKit

protocol GifListCollectionCellBtnFavDelegate: AnyObject {
    func btnFavAction(rowNo: Int)
}

class GifListCollectionCell: UICollectionViewCell {
    weak var delegateFavBtn: GifListCollectionCellBtnFavDelegate?
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var gifImgVw: UIImageView!
    
    @IBOutlet weak var favBtnImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnFavClicked(_ sender: UIButton) {
        if let delegateFavBtn = self.delegateFavBtn {
            delegateFavBtn.btnFavAction(rowNo: btnFav.tag);
        }
    }
}
