package com.shoppingmall.home;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.shoppingmall.home.bo.HomeViewBO;
import com.shoppingmall.home.model.HomeView;

@Controller
public class HomeController {

	@Autowired
	private HomeViewBO homeViewBO;
	
	/**
	 * 홈화면
	 * @param sort
	 * @param model
	 * @return
	 */
	@RequestMapping("/home/home_view") 
	public String homeView(
			@RequestParam(value="sort", required=false) String sort,
			Model model) {
		
		List<HomeView> homeViewList = homeViewBO.generateHomeView(sort);
		
		model.addAttribute("homeViewList", homeViewList);
		model.addAttribute("viewName", "home/home");
		return "template/layout";
	}
}
