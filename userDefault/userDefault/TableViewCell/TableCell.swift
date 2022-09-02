//
//  TableCell.swift
//  examDemoApp
//
//  Created by iMac on 29/07/22.
//

import UIKit

class TableCell: UITableViewCell {

    //MARK: Outlet Declare
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblSystemDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
