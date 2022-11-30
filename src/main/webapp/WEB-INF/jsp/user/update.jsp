<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="d-flex justify-content-center">
	<div class="w-100 d-flex justify-content-center">
		<%-- 왼쪽 메뉴 --%>
		<aside class="col-1 d-flex justify-content-center">
			<div class="pt-5">
				<div>
					<button class="btn btn-info mb-3" onClick="location.href='/basket_order/order_list_view'">주문 내역</button>
				</div>
				<div>
					<button class="btn btn-info mb-3"  onClick="location.href='/user/update_view'">회원정보 수정</button>
				</div>
				<c:if test="${userType eq 2}">
					<div>
						<button class="btn btn-info mb-3" onClick="location.href='/basket_order/seller_order_list_view'">상점 주문 내역</button>
					</div>
				</c:if>
			</div>
		</aside>
		<section class="col-8 pl-5">
			<div class="gray-box">
				<h1 class="text-center">회원 정보 수정</h1>
				<form method="post" id="userUpdateForm" action="/user/update">
					<%-- 아이디 --%>
					<div class="d-flex align-items-center mb-3 mt-3 pl-5">
						<label class="pr-4 mr-2">아이디</label>
						<input type="text" class="ml-4 form-control col-3" name="loginId" value="${userLoginId}" disabled>
					</div>
					<%-- 비밀번호 --%>
					<div class="d-flex align-items-center mb-3 pl-5">
						<label for="password" class="pr-4 mr-2">비밀번호</label>
						<input type="password" class="ml-4 form-control col-4" id="password">
					</div>
					<div class="d-flex align-items-center mb-3 pl-5">
						<label for="loginId" class="pr-1">비밀번호 확인</label>
						<input type="password" class="ml-3 form-control col-4" id="passwordConfirm">
					</div>
					<%-- 이름 --%>
					<div class="d-flex align-items-center mb-3 pl-5">
						<label for="name" class="pr-5">이름</label>
						<input type="text" class="ml-4 form-control col-4" id="name" name="name" value="${userName}" placeholder="${userName}">
					</div>
					<%-- 주소 --%>
					<div class="d-flex align-items-center mb-3 pl-5">
						<label class="pr-5">주소</label>
						<c:set value="${fn:split(userAddress, '/')}" var="addressArr"/>
						<div class="address-box">
							<input type="text" class="address ml-4 mb-1 form-control col-5" id="postcode" placeholder="${addressArr[0]}"  value="${addressArr[0]}">
							<input type="text" class="address ml-4 mb-1 form-control col-8" id="roadAddress" placeholder="${addressArr[1]}" value="${addressArr[1]}">
							<input type="text" class="ml-4 form-control col-10" id="extraAddress" placeholder="${addressArr[2]}" value="${addressArr[2]}">
						</div>
					</div>
					<%-- 전화번호 --%>
					<div class="d-flex align-items-center mb-3 pl-5">
						<label for="phoneNumber">전화 번호</label>
						<input type="text" class="ml-4 form-control col-5 mr-4" id="phoneNumber" name="phoneNumber" value="${userPhoneNumber}" placeholder="${userPhoneNumber}">
						<button id="phoneNumCheckBtn" type="button" class="btn btn-info">중복 체크</button>
					</div>
					<%-- 전화번호 중복 체크 결과 --%>
					<div class="pl-5">
						<div class="text-danger d-none" id="duplicatePhoneNumberWarn">전화번호가 중복됩니다.</div>
						<div class="text-primary d-none" id="availablePhoneNumber">사용가능한 전화번호 입니다</div>
					</div>
					<div class="d-flex justify-content-center">
						<button type="submit" class="btn btn-dark" id="userUpdateBtn">회원정보 수정</button>
					</div>
				</form>
			</div>
		</section>
	</div>
</div>

<script>
	$(document).ready(function() {
		// 전화번호는 blur 일때 숫자가 아닌 값을 모두 지운다.
		$('#phoneNumber').on('blur', function() {
			$(this).val($(this).val().replace(/[^0-9]/g,""));
			return false;
		});
		
		
		
		// 팝업 창을 통한 입력만 가능하도록한다. (우편번호를 주소와 다르게 쓰는 것 방지)
		$('.address').on('keyup', function() {
			// 팝업 창을 띄우기 위한 클릭은 alert 없음
			if ($('#postcode').val().length < 1) {
				return false;
			}
			alert('우편번호와 주소가 다릅니다. 우편번호 재확인 바랍니다.');
			$('#postcode').val("");
			$('#roadAddress').val("");
			$('#extraAddress').val("");
			return false;
		});
		
		
		<%-- 핸드폰 번호 중복 검사 --%>
		$('#phoneNumCheckBtn').on('click', function() {
			$('#duplicatePhoneNumberWarn').addClass('d-none');
			$('#availablePhoneNumber').addClass('d-none');
			
			let phoneNumber = $('#phoneNumber').val();
			if (phoneNumber.length < 1) {
				alert("전화번호를 입력해주세요");
				return;
			}
			$.ajax({
				url: "/user/is_duplicated_phone_number"
				, data: {"phoneNumber":phoneNumber}
				, success: function(data) {
					if (data.isDuplicatedPhoneNumber) {
						$('#availablePhoneNumber').addClass('d-none');
						$('#duplicatePhoneNumberWarn').removeClass('d-none');
						return;
					} else {
						$('#availablePhoneNumber').removeClass('d-none');
						$('#duplicatePhoneNumberWarn').addClass('d-none');
						return;
					}
				}
				, error: function(e) {
					alert("아이디 중복 조회에 실패했습니다. 관리자에게 문의바랍니다");
					return;
				}
			}); // ajax 끝
		}); // 전화 번호 중복 끝
		
		// 전화 번호 수정시 멘트 초기화
		$('#phoneNumber').on('keyup', function() {
			$('#duplicatePhoneNumberWarn').addClass('d-none');
			$('#availablePhoneNumber').addClass('d-none');
		});
		
		<%-- 유효성 검사 --%>
		$('#userUpdateForm').on('submit', function(e) {
			e.preventDefault();
			
			// 비밀번호 검사
			let password = $('#password').val();
			let passwordConfirm = $('#passwordConfirm').val();
			
			if (password != passwordConfirm) {
				alert('비밀번호와 비밀번호 확인이 일치하지 않습니다');
				return;
			}
			// 비밀번호를 변경하지만 4글자가 안된다면 return
			if (password.length >= 1 && password.length < 4) {
				alert("비밀번호를 4글자 이상 입력해주세요");
				return;
			}
			
			// 이름 검사
			let name = $('#name').val();
			if (name.length < 1) {
				alert("이름을 입력해주세요");
				return;
			};
			
			// 주소 검사
			let postcode = $('#postcode').val();
			let roadAddress = $('#roadAddress').val();
			let extraAddress = $('#extraAddress').val();
			
			let address = postcode + "/" + roadAddress  + "/" + extraAddress;
			if (postcode.length < 1) {
				alert('우편번호가 선택되지 않았습니다. 주소를 입력해주세요');
				return;
			}
			
			// 전화번호 검사
			let phoneNumber = $('#phoneNumber').val();
			if(!$('#duplicatePhoneNumberWarn').hasClass('d-none')) {
				alert("전화번호 중복입니다");
				return;
			}
			
			let url = $(this).attr('action');
			let params = $(this).serialize();
			
			// address 는 나눠서 값이 나오기에 따로 추가
			params += "&address=" + address;
			
			// 비밀번호는 썼을때만 넘긴다.
			if (password != "") {
				params += "&password=" + password;
			}
			
			$.post(url, params)
			.done(function(data) {
				if (data.code == 300) {
					alert("회원정보 수정완료");
					location.href = "/user/sign_in_view";
				} else {
					alert(data.errorMessage);
				}
			});
		});
		
	});
</script>
<%-- 카카오 지도 우편번호 API --%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	$('.address').on('click', function addressPopup() {
		  	new daum.Postcode({
	            oncomplete: function(data) {
	                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

	                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	                var roadAddr = data.roadAddress; // 도로명 주소 변수
	                var extraRoadAddr = ''; // 참고 항목 변수

	                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                    extraRoadAddr += data.bname;
	                }
	                // 건물명이 있고, 공동주택일 경우 추가한다.
	                if(data.buildingName !== '' && data.apartment === 'Y'){
	                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                }
	                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                if(extraRoadAddr !== ''){
	                    extraRoadAddr = ' (' + extraRoadAddr + ')';
	                }

	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('postcode').value = data.zonecode;
	                document.getElementById("roadAddress").value = roadAddr;
	                
	                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
	                if(roadAddr !== ''){
	                    document.getElementById("extraAddress").value = extraRoadAddr;
	                } else {
	                    document.getElementById("extraAddress").value = '';
	                }
	            }
	        }).open();
	    });
</script>