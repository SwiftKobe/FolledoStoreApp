//
//  ProductDetailViewController.swift
//  FolledoEcommerceApp
//
//  Created by Samuel Folledo on 11/26/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController, UIScrollViewDelegate { //PB ep68 0mins
   
   
//MARK: IBOutlet
   @IBOutlet weak var scrollView: UIScrollView!
   @IBOutlet weak var detailSummaryView: DetailSummaryView! //PB ep68 2mins contentView
   
   @IBOutlet weak var productDescriptionImageView: UIImageView!
   
   
   @IBOutlet weak var productDescriptionLabel: UILabel!
   
   @IBOutlet weak var tableView: UITableView!
   
//MARK: Properties
   var product: Product? { //PB ep68 11mins so we're going to initiate the update of the detail summary view whenever a product has been set. In order to do that, we need a computed property with didSet
      didSet { //PB ep68 11mins
         if let currentProduct = product { //PB ep68 12mins check if product is nil or not. If product is not nil, then we pass in that product to the detailSummaryView
            self.showDetail(for: currentProduct) //PB ep68 14mins //PB ep72 2mins specification was added in showDetail
         }
      }
   }
   
   
   var specifications = [ProductInfo]() //PB ep72 1mins ProductInfo entity. //showDetail(for:)
   var quantity = 1 //PB ep74 8mins will store the TVC's quantity passed down from the delegate method. First time will be 1
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.scrollView.delegate = self
   }
   
   
//MARK: Private
   private func showDetail(for currentProduct: Product) { //PB ep68 12mins before we load the product into the detailSummaryView, we check if the view is ready to recieve a product or not (view needs to be loaded first)
      if viewIfLoaded != nil { //PB ep68 13mins
         detailSummaryView.updateView(with: currentProduct) //PB ep68 14mins pass our currentProduct //now we can call this method in our computed product
         
         let productInfo = currentProduct.productInfo?.allObjects as! [ProductInfo] //PB ep72 2mins when the currentProduct is being passed from the didSet computed property we have at top, we will be able to capture the productInfo for this currentProuct as we also have a relationship of productInfo in our xcodeDataModel //PB ep72 3mins productInfo NSSet can be convert it to an array by calling .allObjects, as! an array of ProductInfo
         self.specifications = productInfo.filter({ $0.type == "specs" }) //PB ep72 productInfo may have several type. In AppDelegate. We set the type to "specs" so for this specification we only want to filer the pipe that has a value of specs. //PB ep72 5-7mins to get the specification from productInfo, we need to filter for this productInfo array //$0 represent an object in the array, this filter loop through every object in productInfo, and each object is represented by $0 and it will be filtered by type = "specs". So if it has a type = "specs" then it will add it to the specification. Specification array now guarantee to only ave the productInfo with a type of "specs"
         
      //description
         var description = ""//PB ep72 7mins capture description
         for currentInfo in productInfo { //PB ep72 8mins
            if let info = currentInfo.info, info.characters.count > 0, currentInfo.type == "description" { //PB ep72 8-9mins currentInfo,info comes from CoreDatamodel //Once we got info we want to make a quick check
                //PB ep72 9mins if condition is fulfilled, then we'll set description = description + info
               description = description + info + "\n\n" //PB ep72 9mins
            }
         }
         
         productDescriptionLabel.text = description //PB ep72 10mins
         productDescriptionImageView.image = Utility.image(withName: currentProduct.mainImage, andType: "png") //PB ep72 10mins
         
         tableView.reloadData() //PB ep72 11mins refresh
      }
   }
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) { //disable horizontal scrolling
      if scrollView.contentOffset.x != 0 {
         scrollView.contentOffset.x = 0
      }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //PB ep74 4mins
      if let identifier = segue.identifier { //PB ep74 4mins switch between segue
         switch identifier { //PB ep74 4mins
         case "toQuantitySegue": //PB ep74 5mins
            let quantityTVC = segue.destination as! QuantityTableViewController //PB ep74 6mins
            quantityTVC.delegate = self //PB ep74 7-8 now that we have the TVC, we can now access the delegate and set it to self. Important to implement the delegate method as an extension
         default: //PB ep74 4mins
            break
            
         }
      }
   }
   
   
}


//MARK: UITableView DataSource
extension ProductDetailViewController: UITableViewDataSource { //PB ep72 11mins
   func numberOfSections(in tableView: UITableView) -> Int { //PB ep72 12mins
      return 1 //PB ep72 12mins
   }
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //PB ep72 12mins
      return self.specifications.count //PB ep72 12mins
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //PB ep72 13mins
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "productInfoCell", for: indexPath) as! ProductInfoTableViewCell //PB ep72 13mins create a cell from storyboard
      cell.productInfo = self.specifications[indexPath.row] //PB ep72 17mins
      return cell //PB ep72 18mins
   }
   //PB ep72 11mins
}


//MARK: QuantityPopover Delegate
extension ProductDetailViewController: QuantityPopoverDelegate { //PB ep74 8mins implementation of the delegate, dont forget to assign quantityTVC.delegate to self in prepare for segue
   
   func updateProductToBuy(withQuantity quantity: Int) { //PB ep74 8mins now we call this method, where we buy the quantity that is selected. To capture the quantity, we need a property we can store this value from the TVC
      self.quantity = quantity //PB ep74 9mins update our quantity the was passed
      detailSummaryView.quantityButton.setTitle("Quantity: \(self.quantity)", for: .normal) //PB ep74 9mins now we can update the text in our buttons, which lives in detailSummaryView //10mins now the calling controller which is ProductDetailVC, will be able to update the quantity and the buttons, but now we need to communicate back this quantity from the QuantityTVC, using didSelectRowAt
   }
}
