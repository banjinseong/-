<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>인하공전 게시판</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") !=null){
			userID = (String) session.getAttribute("userID");
		}else{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인한 회원만 들어올 수 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		String userJob = null;
		if(session.getAttribute("userJob") !=null){
			userJob = (String) session.getAttribute("userJob");
		}
		if(!userJob.equals("건축학부")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('다른 학부생은 들어올 수 없습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		String job = "CTBBS";
		int pageNumber =1;
		if(request.getParameter("pageNumber") != null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
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
				<li><a href="main.jsp">메인</a>
				<li><a href="bbs.jsp">자유 게시판</a>
				<li class="active" class="dropdown"><a href="#" class="dropdown-toggle" 
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">학부별 게시판<span class="caret"></span></a>
					<ul	class="dropdown-menu">
						<li><a href="mcbbs.jsp">기계공학부</a></li>
						<li><a href="ifbbs.jsp">정보산업공학부</a></li>
						<li><a href="cpbbs.jsp">컴퓨터정보공학부</a></li>
						<li class="active"><a href="ctbbs.jsp">건축학부</a></li>
						<li><a href="svbbs.jsp">서비스학부</a></li>
					</ul>
				</li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle" 
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul	class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			
		</div>
	</nav>
	<div class="container"">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호
						<th style="background-color: #eeeeee; text-align: center;">제목
						<th style="background-color: #eeeeee; text-align: center;">작성자
						<th style="background-color: #eeeeee; text-align: center;">작성일
					</tr>
				</thead>
				<tbody>
					<%
						BbsDAO bbsDAO = new BbsDAO();
						ArrayList<Bbs> list = bbsDAO.getList(pageNumber, "ctbbs");
						for(int i =0; i< list.size(); i++){
					%>
					<tr>
						<td><%= list.get(i).getBbsID() %>
						<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>&userJob='건축학부'"> <%= list.get(i).getBbsTitle() %></a>
						<td><%= list.get(i).getUserID() %>
						<td><%= list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11,13)+"시 " + list.get(i).getBbsDate().substring(14,16) + "분"%>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
				if(pageNumber !=1){
			%>
				<a href="ctbbs.jsp?pageNumber=<%=pageNumber - 1%>" class="btn btn-success btn-arraw-left">이전</a>
			<%
				}if(bbsDAO.nextPage(pageNumber + 1, "ctbbs")){
			%>	
				<a href="ctbbs.jsp?pageNumber=<%=pageNumber + 1%>" class="btn btn-success btn-arraw-left">다음</a>
			<%
				}
			%>	
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
			<br><br>
<div class="container">
		<div class="row pull-left">
			<form method="post" name="search" action="searchbbs.jsp?job=<%=job%>">
				<table class="pull-right">
					<tr>
						<td><select class="form-control" name="searchType">
								<option value="0">선택</option>
								<option value="bbsTitle">제목</option>
								<option value="userID">작성자</option>
						</select></td>
						<td><input type="text" class="form-control"
							placeholder="검색어 입력" name="searchText" maxlength="100"></td>
						<td><button type="submit" class="btn btn-success">검색</button></td>
					</tr>

				</table>
			</form>
		</div>
	</div>				
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>