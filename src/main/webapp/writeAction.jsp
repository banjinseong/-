<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page"/>
<jsp:setProperty property="bbsTitle" name="bbs"/>
<jsp:setProperty property="bbsContent" name="bbs"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>인하공전 게시판</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		String userJob = null;
		if(session.getAttribute("userJob") !=null){
			userJob = (String) session.getAttribute("userJob");
		}
		if(!userJob.equals(request.getParameter("bbsJob")) && !request.getParameter("bbsJob").equals("자유게시판")){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('글작성 권한이 없습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else{
			if(bbs.getBbsTitle()==null || bbs.getBbsContent()==null){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			}else{
				BbsDAO bbsDAO= new BbsDAO();
				int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent(), request.getParameter("bbsJob"));
				if(result == -1){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else{
					PrintWriter script = response.getWriter();
					if(request.getParameter("bbsJob").equals("기계공학부")) {
						script.println("<script>");
						script.println("location.href = 'mcbbs.jsp'");
						script.println("</script>");
					}else if(request.getParameter("bbsJob").equals("정보산업공학부")) {
						script.println("<script>");
						script.println("location.href = 'ifbbs.jsp'");
						script.println("</script>");
					}else if(request.getParameter("bbsJob").equals("컴퓨터정보공학부")) {
						script.println("<script>");
						script.println("location.href = 'cpbbs.jsp'");
						script.println("</script>");
					}else if(request.getParameter("bbsJob").equals("건축학부")) {
						script.println("<script>");
						script.println("location.href = 'ctbbs.jsp'");
						script.println("</script>");
					}else if(request.getParameter("bbsJob").equals("서비스학부")) {
						script.println("<script>");
						script.println("location.href = 'svbbs.jsp'");
						script.println("</script>");
					}else {
						script.println("<script>");
						script.println("location.href = 'bbs.jsp'");
						script.println("</script>");
					}
				}
			}
		
		}
		
	%>
</body>
</html>