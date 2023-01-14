<%@page import="comment.Comment"%>
<%@page import="comment.CommentDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="comment.CommentDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
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
		}
		String userJob= "";
		if((String)request.getParameter("userJob") != null){
			userJob=(String)request.getParameter("userJob");	
		}
		String job = null;
		if(request.getParameter("job") != null){
			job = request.getParameter("job");
		}
		if(userJob.equals("기계공학부")) {
			job = "mcbbs";
		}else if(userJob.equals("정보산업공학부")) {
			job = "ifbbs";
		}else if(userJob.equals("컴퓨터정보공학부")) {
			job = "cpbbs";
		}else if(userJob.equals("건축학부")) {
			job = "ctbbs";
		}else if(userJob.equals("서비스학부")) {
			job = "svbbs";
		}else if(userJob.equals("자유게시판")){
			job="bbs";
		}
		int bbsID = 0;
		if(request.getParameter("bbsID") != null){
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID==0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID, userJob);
		int commentNumber =1;
		if(request.getParameter("commentNumber") != null){
			commentNumber = Integer.parseInt(request.getParameter("commentNumber"));
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
					userID = "비로그인";
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
	<div class="container"">
		<div class="row">	
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글보기
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%">글제목
						<td colspan="2"><%=bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%=bbs.getUserID() %></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%=bbs.getBbsDate().substring(0,11) + bbs.getBbsDate().substring(11,13)+"시 " + bbs.getBbsDate().substring(14,16) + "분" %></td>
					</tr>
					<tr>  
						<td>내용</td>
						<td colspan="2" style="text-align: left;">
						<div style="min-height:200px">
						<%=bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %>
						</div>
						</td>
					</tr>			
				</tbody>				
			</table>
			<a href="<%=job %>.jsp" class="btn btn-primary">목록</a>
			<%
				if(userID != null && userID.equals(bbs.getUserID())){
			%>
				<a href="update.jsp?bbsID=<%=bbsID%>&userJob=<%=userJob %>" class="btn btn-primary">수정</a>
				<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%=bbsID%>&userJob=<%=userJob %>" class="btn btn-primary">삭제</a>
			<%
				}
			%>
			<br><br>
<div class="container">
	<div class="row">
		<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
			<tbody>
				<tr>
					<td align="left" bgcolor="beige">댓글</td>
				</tr>
				<tr>
				<%
					CommentDAO commentDAO = new CommentDAO();
					ArrayList<Comment> list = commentDAO.getList(bbsID, job, commentNumber);
					for(int i=0; i<list.size(); i++){
				%>
						<div class="container">
							<div class="row">
								<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
									<tbody>
										<tr>						
											<td align="left"><%= list.get(i).getUserID() %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= list.get(i).getCommentDate().substring(0,11) + list.get(i).getCommentDate().substring(11,13) + "시" + list.get(i).getCommentDate().substring(14,16) + "분" %></td>		
											<td colspan="2"></td>
											<td align="right">
												<%
												if(list.get(i).getUserID() != null && list.get(i).getUserID().equals(userID)){   //댓글 쓴사람과 지금 유저가 같을 때 수정과 삭제를 가능하게 함
												%>
														<a onclick="return confirm('정말로 삭제하시겠습니까?')" href = "commentDeleteAction.jsp?commentID=<%= list.get(i).getCommentID() %>&job=<%=job %>&bbsID=<%=bbsID %>" class="btn-primary">삭제</a>																	
												<%
												}
												%>	
											</td>
										</tr>
										<tr>
										<td colspan="5" align="left"><%= list.get(i).getCommentText() %>
										</tr>
		
									</tbody>
								</table>	
										
							</div>
						</div>
						<%
							}
						%>
				</tr>
			
		</table>
		<%
			if(commentNumber !=1){
		%>
			<a href="view.jsp?bbsID=<%=bbsID %>&job=<%=job %>&commentNumber=<%=commentNumber - 1%>" class="btn btn-success btn-arraw-left">이전</a>
		<%
			}if(commentDAO.nextPage(commentNumber + 1, job, bbsID)){
		%>	
			<a href="view.jsp?commentNumber=<%=commentNumber + 1%>&bbsID=<%=bbsID %>&job=<%=job %>" class="btn btn-success btn-arraw-left">다음</a>
		<%
			}
		%>	
	</div>
</div>
			<div class="container">
				<div class="form-group">
					<form method="post" action="commentAction.jsp?bbsID=<%= bbsID %>&boardID=<%=job%>">
						<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
							<tr>
								<td style="border-bottom:none;" valign="middle"><br><br><%= userID %></td>
								<td><input type="text" style="height:100px;" class="form-control" placeholder="댓글을 작성하세요." name = "commentText"></td>
								<td><br><br><input type="submit" class="btn-primary pull" value="댓글 작성"></td>
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