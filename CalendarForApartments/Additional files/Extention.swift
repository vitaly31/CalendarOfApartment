//
//  Extention.swift
//  CalendarForApartments
//
//  Created by Виталий Косинов on 10/06/2020.
//  Copyright © 2020 Виталий Косинов. All rights reserved.
//

import UIKit

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionInsets.left * (itemPerRow + 2)
        let avalibleWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avalibleWidth / itemPerRow
        let paddingHight = sectionInsets.left * (itemPerColumn)
        let avalibleHight = collectionView.frame.height - paddingHight
        let hightPerItem = avalibleHight / itemPerColumn
        return CGSize(width: widthPerItem, height: hightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
