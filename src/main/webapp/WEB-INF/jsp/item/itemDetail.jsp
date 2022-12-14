<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div class="d-flex justify-content-center">
	<div class="w-75">
		<div class="d-flex justify-content-center mt-2">
			<a href="/shop/shop_view/${itemDetailView.sellerLoginId}">
				<span class="item-detail-shop-name">${itemDetailView.seller.shopName}</span>
			</a>
		</div>
		<hr>
		<div class="item-detail-box d-flex">
			<div class="w-50 d-flex justify-content-center align-items-center">
				<img alt="썸네일이미지" src="${itemDetailView.item.thumbnailImg}" width="550px" height="400px">
			</div>
			<div class="w-50">
				<div class="ml-3 pt-5 d-flex justify-content-between">
					<h1>${itemDetailView.item.name}</h1>
					<fmt:formatNumber value="${itemDetailView.item.price}" type="number" var="price"/>
					<h1 class="text-success mr-5">${price} 원</h1>
				</div>
				<hr>
				<div class="d-flex justify-content-end mr-5">
					<fmt:formatNumber value="${itemDetailView.item.deliveryPrice}" type="number" var="deliveryPrice"/>
					<h2>배송비 ${deliveryPrice}원</h2>
				</div>
				<hr>
				<div>
					<c:choose>
						<%-- 상품을 올린 상점과 유저 일치 여부에 따라 보이는 버튼 --%>
						<c:when test="${!itemDetailView.isUserSeller}">
							<div class="d-flex justify-content-end">
								<div class="d-flex justify-content-end input-group col-6">
									<div class="input-group-prepend">
										<button class="count-btn btn btn-secondary" id="minusBtn"><b>-</b></button>
									</div>
									<input type="text" id="buyCount" value="1" class="form-control col-2 text-center">
									<div class="input-group-append">
										<button class="count-btn mr-3 btn btn-secondary" id="plusBtn"><b>+</b></button>
									</div>
								</div>
								<div class="col-4 d-flex align-items-end text-success">
									<input type="text" class="d-none" id="itemTotalPrice" data-item-price="${price}" data-item-delivery-price="${deliveryPrice}">
									<h5><b>총 상품 금액 <span id="itemTotalSpan">${price + deliveryPrice}</span></b></h5>
								</div>
							</div>
							<div class="d-flex justify-content-end mr-5 mt-3">
								<form action="/message/message_view" method="post" id="messageViewForm">
									<input type="text" name="sellerId" class="d-none" value="${itemDetailView.seller.id}">
									<button class="btn btn-dark mr-3" type="submit" id="messageViewBtn">상점 문의(쪽지)</button>
								</form>
								<button class="btn btn-info mr-3" type="button" id="basketBtn" data-item-id="${itemDetailView.item.id}">장바구니</button>
								<button class="btn btn-warning" type="button" id="directOrderBtn" data-item-id="${itemDetailView.item.id}">바로 주문하기</button>
							</div>
						</c:when>
						<c:otherwise>
							<div class="d-flex justify-content-end mr-5">
								<button class="btn btn-info mr-3" onClick="location.href='/item/item_update_view?id=${itemDetailView.item.id}'">수정하기</button>
								<button class="btn btn-danger" type="button" id="deleteBtn" data-item-id="${itemDetailView.item.id}">삭제하기</button>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
		<div class="item-detail-box">
			<div>
			<%-- 탭들 --%>
				<ul class="nav nav-tabs pl-5">
				  <li class="nav-item">
				    <a class="nav-link active" href="#" data-show-content="content">상품 정보</a>
				  </li>
				  <li class="nav-item">
				    <a class="nav-link" href="#" data-show-content="review">리뷰</a>
				  </li>
				  <li class="nav-item">
				    <a class="nav-link" href="#" data-show-content="seller">상점 정보</a>
				  </li>
				</ul>
			</div>
			<%-- 탭 선택에 따라 보여지는 정보들 --%>
			<div class="mt-5">
				<div id="itemContent" class="tab-info">
					${itemDetailView.item.content}
				</div>
				<%--  리뷰 --%>
				<div id="review" class="tab-info d-none">
					<div class="pl-5">
						<c:forEach items="${itemDetailView.reviewViewList}" var="reviewView">
							<div class="review-box border p-3 mb-4">
								<div class="d-flex align-items-end">
									<h2 class="m-0">${reviewView.userLoginId}</h2>
									<span class="text-secondary ml-2"><fmt:formatDate value="${reviewView.review.createdAt}" pattern="MM월 dd일"/></span>
								</div>
								<c:forEach var="point" begin="1" end="5">
									<c:choose>
										<c:when test="${reviewView.review.point >= point}">
											<img src="/static/img/star_yellow.png" width="25px">
										</c:when>
										<c:otherwise>
											<img src="/static/img/star_grey.png" width="25px">
										</c:otherwise>
									</c:choose>
								</c:forEach>
								<div class="review-box pt-2">
									<div>
										<h5 id="reviewContent${reviewView.review.id}">${reviewView.review.content}</h5>
										<%-- 리뷰 수정용 --%>
										<div class="d-none bg-light border">
											<div class="ml-2">
												<label>
									      			<input type="radio" value="1" name="point" class="point-star d-none">
										      		<img alt="별점" src="/static/img/star_yellow.png" width="20px;" class="star">
									      		</label>
									      		<label>
									      			<input type="radio" value="2" name="point" class="point-star d-none">
										      		<img alt="별점" src="/static/img/star_yellow.png" width="20px;" class="star">
									      		</label>
									      		<label>
									      			<input type="radio" value="3" name="point" class="point-star d-none">
										      		<img alt="별점" src="/static/img/star_yellow.png" width="20px;" class="star">
									      		</label>
									      		<label>
									      			<input type="radio" value="4" name="point" class="point-star d-none">
										      		<img alt="별점" src="/static/img/star_yellow.png" width="20px;" class="star">
									      		</label>
									      		<label>
									      			<input type="radio" value="5" name="point" class="point-star d-none">
										      		<img alt="별점" src="/static/img/star_yellow.png" width="20px;" class="star">
									      		</label>
											</div>
											<input type="text" value="${reviewView.review.content}" class="form-control border-0 bg-light">
											<div class="d-flex justify-content-end mt-2">
												<button class="update-insert-btn btn text-success btn-light" data-review-id="${reviewView.review.id}" data-point="5">등록</button>									
												<button class="update-cancel-btn btn btn-light btn-border">취소</button>									
											</div>
										</div>
										<c:if test="${reviewView.review.userId eq userId}">
											<div class="d-flex justify-content-end">
												<a href="#none" class="update-review text-success pr-3">수정</a>
												<a href="#none" class="del-review text-danger" data-review-id="${reviewView.review.id}">삭제</a>
											</div>
										</c:if>
									</div>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
				<%-- 상점 정보 --%>
				<div id="sellerInfo" class="tab-info d-none w-100">
					<div class="d-flex justify-content-center">
						<div class="w-50">
							<table class="table">
								<tr>
									<td><b>상호명</b></td>
									<td>${itemDetailView.seller.shopName}</td>
								</tr>
								<tr>
									<c:set value="${fn:replace(itemDetailView.seller.address, '/', ' ')}" var="addressArr"/>
									<td><b>주소</b></td>
									<td>${addressArr} </td>
								</tr>
								<tr>
									<td><b>연락처</b></td>
									<td>${itemDetailView.seller.shopPhoneNumber}</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
	$(document).ready(function() {
		
		<%-- (-) 버튼 클릭시 클릭시 --%>
		$('#minusBtn').on('click', function() {
			let buyCount = parseInt($('#buyCount').val()) - 1;
			if (buyCount <= 0) {
				alert("1보다 작은 수량은 주문할 수 없습니다");
				$('#buyCount').val(1);
				return false;
			}
			$('#buyCount').val(buyCount);
			// 총금액에 갯수 넣어주고 함수 실행
			$('#itemTotalPrice').data('buy-count', buyCount);
			$('#itemTotalPrice').change();
			 return false;
		});
		
		<%-- (+) 버튼 클릭시 클릭시 --%>
		$('#plusBtn').on('click', function() {
			let buyCount = parseInt($('#buyCount').val()) + 1;
			if (buyCount <= 0) {
				alert("1보다 작은 수량은 주문할 수 없습니다");
				$('#buyCount').val(1);
				return false;
			}
			$('#buyCount').val(buyCount);
			// 총금액에 갯수 넣어주고 함수 실행
			$('#itemTotalPrice').data('buy-count', buyCount);
			$('#itemTotalPrice').change();
			return false;
		});
		
		$('#itemTotalPrice').on('change', function() {
			let itemPrice = $(this).data('item-price');
			let buyCount = $(this).data('buy-count');
			let itemDeliveryPrice = $(this).data('item-delivery-price');
			
			$('#itemTotalPrice').val(itemPrice * buyCount + itemDeliveryPrice);
			$('#itemTotalSpan').text($('#itemTotalPrice').val());
		});
		
		<%-- 수량이 직접 입력될때 --%>
		$('#buyCount').on('keyup', function() {
			let buyCount = $('#buyCount').val();
			
			if (buyCount <= 0) {
				alert("1보다 작은 수량은 주문할 수 없습니다");
				$('#buyCount').val(1);
				$('#itemTotalPrice').data('buy-count', 1);
				$('#itemTotalPrice').change();
				return false;
			}
			$('#itemTotalPrice').data('buy-count', buyCount);
			$('#itemTotalPrice').change();
		});
		
		<%-- 탭 메뉴 클릭시 보여주는 정보 --%>
		$('.nav-item').on('click', function(e) {
			e.preventDefault();
			$('.nav-item').children().removeClass('active');
			$(this).children().addClass('active');
			
			
			// 보여줄 내용
			let showContent = $(this).children().data('show-content');
			if (showContent == 'content') {
				$('.tab-info').addClass('d-none');
				$('#itemContent').removeClass('d-none');
			} else if (showContent == 'seller') {
				$('.tab-info').addClass('d-none');
				$('#sellerInfo').removeClass('d-none');
			} else if (showContent == 'review') {
				$('.tab-info').addClass('d-none');
				$('#review').removeClass('d-none');
				$('#sellerInfo').addClass('d-none');
			}
			return false;
			
		});
		
		<%-- 삭제(상품) 버튼 클릭시 --%>
		$('#deleteBtn').on('click', function() {
			
			let itemId = $(this).data('item-id');
			let sellerLoginId = "${userLoginId}";
			
			$.ajax({
				 type:"DELETE"
				 ,data:{"itemId":itemId}
			 	 ,url: "/item/delete"
			 	 ,success:function(data){
			 		 if(data.code == 300) {
			 			 alert(data.result);
			 			 location.href = "/shop/shop_view/" + sellerLoginId;
			 		 } else if (data.code == 550) {
						alert(data.errorMessage);
						location.href = "/user/sign_in_view";	
			 		 } else {
			 			 alert(data.errorMessage);
			 		 }
			 	 }
			 	 , error:function(e) {
			 		 alert("상품 삭제에 실패했습니다. 관리자에게 문의 주세요");
			 	 }
			 })
		}); // 삭제 끝
		
		
		
		<%-- 장바구니 넣기 --%>
		$('#basketBtn').on('click', function() {
			// 로그인 되어있지 않다면 로그인 화면으로 이동
			if (${userId eq null}) {
				alert('로그인 후 이용가능 합니다.');
				location.href = "/user/sign_in_view";
				return;
			}
			
			let itemId = $(this).data('item-id');
			let number = $('#buyCount').val();
			
			if (number <= 0) {
				alert('최소 1개 이상 장바구니에 넣을 수 있습니다.');
				return;
			}
			
			$.ajax({
				 type:"POST"
				 , data:{"itemId":itemId, "number":number}
				 , url:"/basket/create"
				 , success:function(data) {
					 if (data.code == 300) {
						 location.href = "/basket/basket_list_view";
					 } else {
						 alert(data.errorMessage);
					 }
				 }
				 , error: function(e) {
					 alert('장바구니 넣기에 실패했습니다. 관리자에게 문의하여 주세요');
				 }
			}); // ajax 끝
		}); // 장바구니 넣기 끝
		
		<%-- 바로 주문하기 버튼 --%>
		$('#directOrderBtn').on('click', function() {
			// 로그인 되어있지 않다면 로그인 화면으로 이동
			if (${userId eq null}) {
				alert('로그인 후 이용가능 합니다.');
				location.href = "/user/sign_in_view";
				return;
			}
			
			// 바로 주문 장바구니에 넣고, 주문서 화면으로 이동
			let itemId = $(this).data('item-id');
			let number = $('#buyCount').val();
			
			if (number <= 0) {
				alert('최소 1개 이상 주문 가능합니다.');
				return;
			}
			
			$.ajax({
			 	data:{"itemId":itemId, "number":number}
				, url:"/direct_basket/create"
				, success:function(data) {
					if (data.code == 300) {
						location.href = "/order/order_create_view?directBasketId=" + data.directBasketId;
					 } else {
						 alert(data.errorMessage);
					 }
				 }
				, error:function(e) {
					alert('바로주문에 실패했습니다. 관리자에게 문의하여 주세요');
				}
			}); // ajax 끝 */
		}); // 바로주문하기
		
		<%-- 리뷰 수정 --%>
		// 리뷰 수정하기
		$('.update-review').on('click', function(e) {
			e.preventDefault();
			$(this).parent().prev().prev().addClass('d-none');
			$(this).parent().prev().removeClass('d-none');
			$('.star').attr('src', "/static/img/star_yellow.png");
		});
		
		<%-- 별점 선택 --%>
		$('.point-star').on('click', function() {
			// 선택된 별점 노랑
			$(this).parent().find('img').attr('src', "/static/img/star_yellow.png");
			// 선택된 별점이전 별점 노랑
			$(this).parent().prevAll().find('img').attr('src', "/static/img/star_yellow.png");
			// 선택된 별점이후 별점 회색
			$(this).parent().nextAll().find('img').attr('src', "/static/img/star_grey.png");
			
			// 선택한 별점 넣기
			$(this).parent().parent().next().next().find('.update-insert-btn').data('point', $(this).val());
		});
		
		
		// 리뷰 수정 취소하기
		$('.update-cancel-btn').on('click', function(e) {
			e.preventDefault();
			$(this).parent().parent().addClass('d-none');
			$(this).parent().parent().prev().removeClass('d-none');
		});
		
		// 리뷰 수정하기
		$('.update-insert-btn').on('click', function(e) {
			let reviewId = $(this).data('review-id');
			let point = $(this).data('point');
			let content = $(this).parent().prev().val();
			console.log(point);
			
			$.ajax({
				type:"PUT"
				,url:"/review/update"
				,data:{"reviewId":reviewId, "point":point, "content":content}
				,success:function(data) {
					if (data.code == 300) {
						alert(data.result);
						location.reload();
					} else {
						alert(data.errorMessage);
					}
				}
				,error:function(e) {
					alert('리뷰 수정에 실패했습니다. 관리자에게 문의주세요');
					
				}
			}); // ajax 끝
		});
		
		<%-- 리뷰 삭제 --%>
		$('.del-review').on('click', function(e) {
			e.preventDefault();
			let reviewId = $(this).data('review-id');
			
			$.ajax({
				type: "DELETE"
				, data:{"reviewId":reviewId}
				, url:"/review/delete"
				, success:function(data) {
					if (data.code == 300) {
						alert(data.result);
						location.reload();
					} else {
						alert(data.errorMessage);
					}
				}
				, error:function(e) {
					alert("리뷰 삭제에 실패했습니다. 관리자에게 문의바랍니다");
				}
			}); // ajax 끝
		});
	});
</script>