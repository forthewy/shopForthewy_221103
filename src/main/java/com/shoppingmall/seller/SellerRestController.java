package com.shoppingmall.seller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.shoppingmall.seller.bo.SellerBO;

@RequestMapping("/seller")
@RestController
public class SellerRestController {
	
	@Autowired
	private SellerBO sellerBO;
	
	@PostMapping("/update")
	public Map<String, Object> update(
			@RequestParam(value="shopName" , required=false) String shopName,
			@RequestParam(value="address" , required=false) String address,
			@RequestParam(value="shopPhoneNumber" , required=false) String shopPhoneNumber,
			@RequestParam(value="bannerImg", required=false) MultipartFile bannerImg,
			@RequestParam(value="shopMainImg", required=false) MultipartFile shopMainImg,
			HttpSession session) {
		
		Integer userId = (Integer) session.getAttribute("userId");
		String userLoginId = (String) session.getAttribute("userLoginId");
		
		
		int row = sellerBO.updateSellerByUserId(userId, userLoginId,  shopName, address, shopPhoneNumber, bannerImg, shopMainImg);
		
		
		Map<String, Object> result = new HashMap<>();
		
		if (row > 0) {
			result.put("code", 300);
			result.put("result", "success");
		} else {
			result.put("code", 500);
			result.put("errorMessage", "상점 정보 수정에 실패했습니다");
		}
		
		return result;
	}
}
