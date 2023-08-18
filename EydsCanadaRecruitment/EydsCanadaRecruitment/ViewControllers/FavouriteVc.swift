//
//  FavouriteVc.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 16/08/23.
//

import UIKit

class FavouriteVc: UIViewController {
    
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    let favouriteVcVmObj = FavouriteVcVM();
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        configUI();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configUI() {
        self.setDefaultGrid();
        self.tblVw.delegate = self;
        self.tblVw.dataSource = self;
        self.tblVw.register(UINib(nibName: "GifDisplayCell", bundle: nibBundle), forCellReuseIdentifier: TableViewCells.gifDisplayCell.identifier);
        self.tblVw.tableFooterView = UIView();
        
        self.collectionVw.delegate = self;
        self.collectionVw.dataSource = self;
        self.collectionVw.register(UINib(nibName: "GifListCollectionCell", bundle: nil), forCellWithReuseIdentifier: CollectionViewCells.gifListCollectionCell.identifier)
        self.getFavGifImges();
    }
    
    func setDefaultGrid() {
        segControl.selectedSegmentIndex = 0;
        self.collectionVw.isHidden = false;
        self.tblVw.isHidden = true;
        DispatchQueue.main.async {[weak self] in
            self?.tblVw.reloadData();
            self?.collectionVw.reloadData();
        }
    }
    
    func getFavGifImges() {
        self.favouriteVcVmObj.getGifImgArrayFromDefaults {
            DispatchQueue.main.async {[weak self] in
                self?.tblVw.reloadData();
                self?.collectionVw.reloadData();
            }
        }
    }
    
    @IBAction func segControlAction(_ sender: Any) {
        switch self.segControl.selectedSegmentIndex {
        case 0:
            self.tblVw.isHidden = true;
            self.collectionVw.isHidden = false;
            DispatchQueue.main.async {[weak self] in
                self?.tblVw.reloadData();
                self?.collectionVw.reloadData();
            }
        case 1:
            self.tblVw.isHidden = false;
            self.collectionVw.isHidden = true;
            DispatchQueue.main.async {[weak self] in
                self?.tblVw.reloadData();
                self?.collectionVw.reloadData();
            }
        default:
            break;
        }
    }
    
}

//MARK: UITABLEVIEW DELEGATE
extension FavouriteVc: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouriteVcVmObj.numOfRows();
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCells.gifDisplayCell.identifier) as? GifDisplayCell {
            cell.giImgVw.image = self.favouriteVcVmObj.getGifImg(rowNo: indexPath.row);
            cell.btnFavourite.tag = indexPath.row;
            cell.imgFavourite.image = UIImage(named: ImagesName.fav.rawValue)
            cell.delegateFavBtn = self;
            return cell;
        } else {
            return UITableViewCell();
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0;
    }
    
}

//MARK: UICOllECIONVIEW DELEGATE
extension FavouriteVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favouriteVcVmObj.numOfRows();
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCells.gifListCollectionCell.identifier, for: indexPath) as? GifListCollectionCell {
            cell.gifImgVw.image = self.favouriteVcVmObj.getGifImg(rowNo: indexPath.row)
            cell.btnFav.tag = indexPath.row;
            cell.favBtnImg.image = UIImage(named: ImagesName.fav.rawValue)
            cell.delegateFavBtn = self;
            return cell;
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width  = (view.frame.width-30)/3
        return CGSize(width: width, height: width)
    }
    
    
}

extension FavouriteVc: GifDisplayCellBtnFavDelegate {
    
    func btnFavouriteAction(rowNo: Int) {
        DispatchQueue.main.async {[weak self] in
            self?.favouriteVcVmObj.btnIsFavourtiteAction(rowNo: rowNo);
            self?.tblVw.reloadData();
            self?.collectionVw.reloadData();
        }
    }
}
extension FavouriteVc: GifListCollectionCellBtnFavDelegate {
    
    func btnFavAction(rowNo: Int) {
        DispatchQueue.main.async {[weak self] in
            self?.favouriteVcVmObj.btnIsFavourtiteAction(rowNo: rowNo);
            self?.collectionVw.reloadData();
            self?.tblVw.reloadData();
        }
    }
}

