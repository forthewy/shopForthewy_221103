<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<div class="w-100 d-flex justify-content-center">
	<div class="w-50">
		<%-- 여기는 메세지 화면 --%>
		<div class="message-box w-100 bg-grey">
			<%-- 날짜 초기 값 --%>
			<c:set value="0000-00-00" var="date"/>
			<c:forEach items="${messageView.messageList}" var="message">
				<fmt:formatDate value="${message.createdAt}" pattern="yyyy-MM-dd" var="messageDate"/>
				<c:if test="${date ne messageDate}">
					<h4 class="text-center">${messageDate}</h4>
					<%-- 같은 날짜는 같이 보도록 한다. --%>
					<c:set value="${messageDate}" var="date"/>
				</c:if>
				<c:choose>
					<%-- 남이 보낸거일때 --%>
					<c:when test="${message.senderUserId ne userId}">
						<div class="d-flex justify-content-start pl-5 pt-3">
							<div class="card text-dark bg-info mb-3">
								 <div class="card-body each-card">
								   <p class="card-text"><b>${message.content}</b></p>
								 </div>
							</div>
							<fmt:formatDate value="${message.createdAt}" pattern="HH:mm" var="messageTime"/>
							<span class="text-light mt-3 ml-2">${messageTime}</span>
						</div>
					</c:when>
					<c:otherwise>
						<div class="d-flex justify-content-end pr-5 pt-3">
							<fmt:formatDate value="${message.createdAt}" pattern="HH:mm" var="messageTime"/>
							<span class="text-light mt-3 mr-2">${messageTime}</span>
							<div class="card text-dark bg-warning mb-3">
								 <div class="card-body each-card">
								   <p class="card-text"><b>${message.content}</b></p>
								 </div>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</div>
		<%-- 메세지 보내기 --%>
		<div class="input-group">
			<label class="d-none" for="messageContent" id="messageContentLabel">메세지</label>
			<input type="text" class="form-control" id="messageContent" name="content">
			<div class="input-group-append">
				<button class="btn btn-dark" type="button" id="sendMessageBtn" data-chatroom-id="${messageView.chatroomId}">보내기</button>
			</div>
		</div>
	</div>
</div>

<script>
	$(document).ready(function() {
		
		$('.message-box').scrollTop(document.body.scrollHeight);
		
		// 메세지를 연속으로 보낼수 있도록 들어오자마자 클릭
		$('#messageContentLabel').click();
		
		$('#messageContent').on("keyup", function(key) {
	        if(key.keyCode == 13) {
	            $('#sendMessageBtn').click();
	        }
	    });
		
		
		<%-- 보내기 버튼 클릭 --%>
		$('#sendMessageBtn').on('click', function() {
			let messageContent = $('#messageContent').val();
			
			//아무 내용 없이는 보낼수 없다.
			if (messageContent == "") {
				alert("내용이 입력되지 않았습니다.");
				return;
			}
			
			let chatroomId = $(this).data('chatroom-id');
			
			$.ajax({
				type: "POST"
				,url: "/message/create"
				,data: {"chatroomId":chatroomId, "content":messageContent}
				,success:function(data) {
					if (data.code == 300) {
						location.reload();
					} else {
						alert(data.errorMessage);
					}
				}
				,error:function(e) {
					alert('문의(쪽지) 보내기에 실패했습니다. 관리자에게 문의해주세요');
				}
			}); // ajax 끝
		});
	});

</script>