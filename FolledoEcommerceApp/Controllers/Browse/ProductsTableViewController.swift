//
//  ProductsTableViewController.swift
//  FolledoEcommerceApp
//
//  Created by Samuel Folledo on 11/24/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController { //PB ep63 9mins
   
   var products: [Product]? //PB ep64 1mins placeholder for the array of products
   var selectedProduct: Product? //PB ep64 8mins select a product so we can have something displayed on the right side of the MasterDetail ViewController
   
   weak var delegate: ProductDetailViewController? //PB ep68 15mins weak to avoid any strong reference cycle, with an optional type of ProductDetailVC //PB ep68 16mins last thing we need to make the connection between master and detail. We need to make sure this delegate with this data type is being initialized when the app is loaded, meaning in App Delegate.swift
   
   
//MARK: LifeCycle
   override func viewDidLoad() { //PB ep63 9mins
      super.viewDidLoad()
      
   }
   
   override func viewWillAppear(_ animated: Bool) { //PB ep64 5mins we will have the browse method called in this lifecycle because once the VC is loaded by viewDidLoad first, viewDidLoad will not be called again. But viewWillAppear will be called everytime it is about to be shown. This will help us not show the same products over and over
      super.viewWillAppear(animated)
      self.products = ProductService.browse() //PB ep64 7mins
      if let products = self.products { //PB ep64 8mins unwrap the products and take at least one
         selectedProduct = products.first //PB ep64 9mins grab the first item from the products list
      }
      tableView.reloadData() //PB ep64 9mins refresh to list be sure
   }
   
   

// MARK: - Table view data source
   override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1 //PB ep64 9mins only one section
   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      if let products = self.products { //PB ep64 9mins unwrap it first
         return products.count //PB ep64 9mins
      }
      return 0
   }
   
//cellForRowAt
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //PB ep64 10mins
      
      tableView.rowHeight = 70 //PB ep64 13mins
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellProduct", for: indexPath) as! ProductsTableViewCell //PB ep64 10mins
      
      if let currentProduct = self.products?[indexPath.row] { //PB ep64 11mins unwrap our products before we set the values of the cells
         if selectedProduct?.id == currentProduct.id { //PB ep64 11mins once we get the current product, need to check if the selectedProduct is equal to the current product.id, then we can make sure that tableView selection is being set to that particular product
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none) //PB ep64 12mins
            
         //attach a border to the selected product
            cell.contentView.layer.borderWidth = 2 //PB ep64 16mins
            cell.contentView.layer.borderColor = UIColor().pirateBay_gold().cgColor //PB ep64 17mins put our brownColor from UIColor+extension to our cell
            
            delegate?.product = selectedProduct //PB ep69 21mins right now we have the first product selected by default, but the productDetail is not showing anything //in order to have productDetail be shown by default we want to set the delegate here //this line makes sure that the first item on the list will have the detail info showing up
            
         } else { //PB ep64 18mins remove the border to the unselected products
            cell.contentView.layer.borderWidth = 0 //PB ep64 18mins
            cell.contentView.layer.borderColor = UIColor.clear.cgColor //PB ep64 18mins
         }
         
      //now we can configure the cell
         cell.configureCell(with: currentProduct)
      }
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //PB ep64 19mins
      selectedProduct = products?[indexPath.row] //PB ep64 19mins set the selected product as the tapped row so we can have a border to the selected one
      
      delegate?.product = selectedProduct //PB ep68 15mins whenever user select a product, we want to call the deleate. //We're basically assigning the product property in the detailView to a product that is being selected
      
      tableView.reloadData() //PB ep64 19mins reload it so we can see the borders
   }
   
   
   
}