//
//  MemeTableViewController.swift
//  memez
//
//  Created by Kenny Leung on 11/26/15.
//  Copyright © 2015 Kenny Leung. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "createMeme")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func createMeme() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("CreateMemeViewController") as! CreateMemeViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.topText!) \(meme.bottomText!)"
        return cell
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
