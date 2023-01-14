<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>인하공전 게시판</title>
<script type="text/javascript">
	function getTime() {
		var d = new Date();	
		var hur = d.getHours();		
		var min = d.getMinutes();	
		var sec = d.getSeconds();	

		var timeBoard = document.getElementById("Time"); 
		
		var time = "현재 시간 : " + hur + "시 " + min + "분 " + sec + "초"	
		
		timeBoard.innerHTML = time;	
		setTimeout(getTime, 1000);	
	}
	
</script>
</head>
<body onload="getTime()">
	<%
		String userID = null;
		if(session.getAttribute("userID") !=null){
			userID = (String) session.getAttribute("userID");
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar=header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-epanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>	
			</button>
			<a class="navbar-brand" href="main.jsp">인하공전 게시판</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="main.jsp">메인</a>
				<li><a href="bbs.jsp">자유 게시판</a>
				<li class="dropdown"><a href="#" class="dropdown-toggle" 
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">학부별 게시판<span class="caret"></span></a>
					<ul	class="dropdown-menu">
						<li><a href="mcbbs.jsp">기계공학부</a></li>
						<li><a href="ifbbs.jsp">정보산업공학부</a></li>
						<li><a href="cpbbs.jsp">컴퓨터정보공학부</a></li>
						<li><a href="ctbbs.jsp">건축학부</a></li>
						<li><a href="svbbs.jsp">서비스학부</a></li>
					</ul>
				</li>
			</ul>
			<%
				if(userID == null){
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle" 
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul	class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
						
					</ul>
				</li>
			</ul>
			<%
				} else{
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle" 
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul	class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%	
				}
			%>
			
		</div>
	</nav>
	<div class="container">
	
		<div class="jumbotron">
			<div class="container">
				<h1>인하공전 전용 게시판</h1>
				<p id="Time"><p>
					<script src="js/background.js"></script>
				<p><a class="btn btn-primary btn-pull" href="https://www.inhatc.ac.kr/sites/kr/index.do" role="button">인하공전 홈페이지</a></p>
			</div>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script src="js/weather.js"></script>

</body>
</html>