//
//  PageVC.swift
//  Barbara_WeatherGift
//
//  Created by Barbara on 3/17/18.
//  Copyright © 2018 Barbara. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var pageControl: UIPageControl!
    var listButton: UIButton!
    var barButtonWidth: CGFloat = 44
    var barButtonHeight: CGFloat = 44
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        let newLocation = WeatherLocation()
        newLocation.name = ""
        locationsArray.append(newLocation)
        
setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)

        }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        confligurePageControl()
        configureListButton()
        
    }
    
    //MARK: make the page control
    
        func confligurePageControl(){
          
            let pageControlHeight: CGFloat = barButtonHeight
            let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth * 2)
            let safeHeight = view.frame.height - view.safeAreaInsets.bottom
            
            pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth)/2, y:
                safeHeight - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
            
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            pageControl.currentPageIndicatorTintColor = UIColor.black
            pageControl.backgroundColor = UIColor.white
             pageControl.numberOfPages = locationsArray.count
            pageControl.currentPage = currentPage
            pageControl.addTarget(self, action: #selector(pageControlPressed), for: .touchUpInside)
            view.addSubview(pageControl)
            }
    
    func configureListButton() {
        let barButtonHeight = barButtonWidth
        let safeHeight = view.frame.height -
            view.safeAreaInsets.bottom
        
        listButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: safeHeight - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        listButton.setBackgroundImage(UIImage(named:"listButton"), for: .normal)
        listButton.setBackgroundImage(UIImage(named:"listButtonhHghlighted"), for: .highlighted)
        listButton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
        view.addSubview(listButton)
    }
    
    
    //MARK: Segue
    @objc func segueToListVC() {
        performSegue(withIdentifier: "ToListVC", sender: nil)
    }
    
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue) {
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        setViewControllers([createDetailVC(forPage: currentPage)], direction: .forward, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentViewController = self.viewControllers?[0] as? DetailVC else {return}
        locationsArray = currentViewController.locationsArray
        if segue.identifier == "ToListVC" {
            let destination = segue.destination as! ListVC
            destination.locationsArray = locationsArray
            destination.currentPage = currentPage
        }
    }
    
    
    //MARK: Create View cONTROLLER FOR uipage control
    func createDetailVC(forPage page: Int) -> DetailVC {
        currentPage = min(max(0, page), locationsArray.count - 1)
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
    
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        
        return detailVC
    }
    
}

extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? DetailVC{
            if currentViewController.currentPage < locationsArray.count - 1{
               return createDetailVC(forPage: currentViewController.currentPage + 1 )
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? DetailVC{
            if currentViewController.currentPage > 0 {
                return createDetailVC(forPage: currentViewController.currentPage - 1 )
            }
        }
        return nil
        
}
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?[0] as?
            DetailVC{
            pageControl.currentPage = currentViewController.currentPage
        }
    }
    
    
    @objc func pageControlPressed() {
        guard let currentViewController = self.viewControllers?[0] as? DetailVC else {return}
        currentPage = currentViewController.currentPage
        if pageControl.currentPage < currentPage {
            setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .reverse, animated: true, completion: nil)
        } else if pageControl.currentPage > currentPage {
            setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .forward, animated: true, completion: nil)
        }
        
    }
}
