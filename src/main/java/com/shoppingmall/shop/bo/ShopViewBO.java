package com.shoppingmall.shop.bo;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import com.shoppingmall.bookmark.bo.BookmarkBO;
import com.shoppingmall.item.bo.ItemBO;
import com.shoppingmall.item.model.Item;
import com.shoppingmall.seller.bo.SellerBO;
import com.shoppingmall.seller.model.Seller;
import com.shoppingmall.shop.model.ShopView;

@Service
public class ShopViewBO {
	
	@Autowired
	private SellerBO sellerBO;
	
	@Autowired
	private ItemBO itemBO;
	
	@Autowired
	private BookmarkBO bookmarkBO;
	
	public ShopView generateShopView(String sellerLoginId, Integer userId, Integer page) {
		
		ShopView shopView = new ShopView();
		
		// 상점객체 가져오기
		Seller seller = sellerBO.getSellerByUserLoginId(sellerLoginId);
		shopView.setSeller(seller);
		
		// 아이템 리스트 가져오기
		List<Item> itemList = itemBO.getItemBySellerIdLimitPage(seller.getId(), page);
		shopView.setItemList(itemList);
		
		// 아이템 갯수 가져오기
		int itemCount = itemBO.getItemCountBySellerId(seller.getId());
		shopView.setItemCount(itemCount);
		
		// 즐겨찾기 여부 확인하기
		boolean isbookMarked = bookmarkBO.existBookmark(seller.getId(), userId);
		shopView.setIsBookmarked(isbookMarked);
		
		return shopView;
	}
}
