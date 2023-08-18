//
//  GifListVc.swift
//  EydsCanadaRecruitment
//
//  Created by Mac-09 on 16/08/23.
//

import UIKit

class GifListVc: UIViewController {
    
    @IBOutlet weak var txtSearchBar: UISearchBar!
    @IBOutlet weak var tblVw: UITableView!
    
    let gifListVm = GiftListVM();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configUI();
    }
    
    func configUI() {
        self.tblVw.delegate = self;
        self.tblVw.dataSource = self;
        self.tblVw.register(UINib(nibName: "GifDisplayCell", bundle: nibBundle), forCellReuseIdentifier: TableViewCells.gifDisplayCell.identifier);
        self.tblVw.tableFooterView = UIView();
        self.txtSearchBar.delegate = self
        self.getGifImgList();
        
    }
    
    func getGifImgList() {
        self.gifListVm.getGifs {
            DispatchQueue.main.async {[weak self] in
                self?.tblVw.reloadData();
            }
        }
    }
}

extension GifListVc: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gifListVm.numOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCells.gifDisplayCell.identifier) as? GifDisplayCell {
            cell.gifUrl = self.gifListVm.getGifImgUrl(rowNo: indexPath.row);
            cell.btnFavourite.tag = indexPath.row;
            cell.imgFavourite.image = self.gifListVm.setIsFavBtnIcon(rowNo: indexPath.row);
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

extension GifListVc: GifDisplayCellBtnFavDelegate {
    
    func btnFavouriteAction(rowNo: Int) {
        DispatchQueue.main.async {[weak self] in
            self?.gifListVm.btnIsFavourtiteAction(rowNo: rowNo);
            
            let indexPath = IndexPath(row: rowNo, section: 0)
            self?.tblVw.reloadRows(at: [indexPath], with: .none);
        }
    }
}

extension GifListVc: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if self.gifListVm.searchBtnAction(searchTxt: searchBar.text ?? "") {
            self.gifListVm.getSearchGifs {[weak self] error in
                if error == nil {
                    self?.tblVw.reloadData();
                } else {
                    print("error is \(String(describing: error))");
                }
            }
        } else {
            self.getGifImgList();
        }
        self.txtSearchBar.endEditing(true)
    }
}
