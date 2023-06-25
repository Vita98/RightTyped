//
//  IndexPath.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/06/23.
//

import Foundation

extension IndexPath{
    public func nearest(withLeftBound bound: Int) -> IndexPath?{
        if self.row == 0 && self.row + 1 > bound { return nil }
        if self.row + 1 <= bound{
            return IndexPath(row: self.row + 1, section: self.section)
        }else if self.row - 1 >= 0{
            return IndexPath(row: self.row - 1, section: self.section)
        } else { return nil }
    }
}
