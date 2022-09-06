//
//  ViewController.swift
//  CodableView
//
//  Created by Skyler Brown on 9/6/22.
//

import UIKit

class MonarchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var monarchTableView: UITableView!
    
    // Array to hold our data from api call
    var monarchs = [Monarch]() {
        didSet {
            DispatchQueue.main.async {
                // Reload tableview when array is populated
                self.monarchTableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        monarchTableView.delegate = self
        monarchTableView.dataSource = self
        
        getData()
        print (monarchs.count)

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // How many rows will be in the table
        return monarchs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Setup for each cell
        let cell = monarchTableView.dequeueReusableCell(withIdentifier: "MonarchCell", for: indexPath) as! MonarchCell
        cell.name.text = monarchs[indexPath.row].Name
        print(cell.name.text)
        
        
        switch cell.name.text {
            
            case "Edward the Elder": cell.picture.image = UIImage(named: "Edward the Elder")
            case "Athelstan": cell.picture.image = UIImage(named: "Athelstan")
            case "Edmund": cell.picture.image = UIImage(named: "Edmund")
            case "Edred": cell.picture.image = UIImage(named: "Edred")
            case "Edwy": cell.picture.image = UIImage(named: "Edwy")
            default: break
        }
            
        
        return cell
    }
    
    func getData() {
        
        guard let url = URL(string: "https://mysafeinfo.com/api/data?list=englishmonarchs&format=json") else {return}
        
        // Create a data session task fetch website data into memory
        let task = URLSession.shared.dataTask(with: url) {data, response, error in
            
            if let taskError = error as? NSError {
                
                // Handle error if there is any
                print(taskError)
                return
            }
            
            guard let data = data else {return}

            let decoder = JSONDecoder()
            
            do {
                
                // Get data from JSON into monarchs struct array
                let monarchsData: [Monarch] = try decoder.decode([Monarch].self, from: data)
                self.monarchs = monarchsData
               
            } catch {
                
                print("Error parsing data from JSON")
            }
            
        }.resume()
    }
}

