package com.shoppingmall.basketOrder;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.shoppingmall.basketOrder.bo.BasketOrderBO;
import com.shoppingmall.basketOrder.model.BasketOrderView;

@Controller
@RequestMapping("/basket_order")
public class BasketOrderController {

	@Autowired
	private BasketOrderBO basketOrderBO;
	
	/**
	 * 유저 주문 조회 목록
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping("/order_list_view")
	public String orderListView(
			HttpSession session,
			Model model) {
		
		int userId = (int)session.getAttribute("userId");
		
		List<BasketOrderView> basketOrderViewList =  basketOrderBO.getBasketOrderViewListByUserId(userId);
		model.addAttribute("basketOrderViewList", basketOrderViewList);
		model.addAttribute("viewName", "order/orderList");
		
		return "template/layout";
	}
	
	@RequestMapping("/seller_order_list_view")
	public String sellerOrderListView(
			HttpSession session,
			@RequestParam(value="searchName", required=false) String searchName,
			Model model) {
		
		int userId = (int)session.getAttribute("userId");
		
		List<BasketOrderView> basketOrderViewList =  basketOrderBO.getBasketOrderViewListBySellerUserIdAndSearchName(userId, searchName);
		
		model.addAttribute("basketOrderViewList", basketOrderViewList);
		model.addAttribute("viewName", "order/sellerOrderList");
		
		return "template/layout";
	}
}
