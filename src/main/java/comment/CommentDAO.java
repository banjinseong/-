package comment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;


public class CommentDAO {
	private Connection conn;
	private ResultSet rs;
	
	public CommentDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID="root";
			String dbPassword = "rootpw";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn=DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return "";//데이터베이스오류
	}
	
	public int getNext(String bbs, int bbsID) {
		String SQL = "SELECT commentID FROM COMMENT WHERE bbsName = " + "'" + bbs + "'" + " AND bbsID = "  + bbsID  + " ORDER BY commentID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; //첫번째 게시물인 경우
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터 베이스 오류		
	}
	
	public ArrayList<Comment> getList(int bbsID, String userJob, int commentNumber){
		String SQL = "SELECT * FROM COMMENT WHERE bbsName = ? AND bbsID = ? AND commentID < ? AND commentAvailable = 1 ORDER BY commentID DESC LIMIT 10";
		ArrayList<Comment> list = new ArrayList<Comment>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userJob);
			pstmt.setInt(2, bbsID);
			pstmt.setInt(3, getNext(userJob, bbsID) - (commentNumber -1) * 10);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Comment comment = new Comment();
				comment.setBbsName(rs.getString(1));
				comment.setCommentID(rs.getInt(2));
				comment.setBbsID(rs.getInt(3));				
				comment.setUserID(rs.getString(4));
				comment.setCommentDate(rs.getString(5));
				comment.setCommentText(rs.getString(6));
				comment.setCommentAvailable(rs.getInt(7));
				list.add(comment);
			}

		}catch (Exception e) {
			e.printStackTrace();
		}
		return list; //데이터 베이스 오류	
	}
	
	public int write(int bbsID, String userID, String bbsContent, String userJob) {
		String SQL = "INSERT INTO COMMENT VALUES (?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setString(1, userJob);
			pstmt.setInt(2, getNext(userJob, bbsID));
			pstmt.setInt(3, bbsID);
			pstmt.setString(4, userID);
			pstmt.setString(5, getDate());
			pstmt.setString(6, bbsContent);
			pstmt.setInt(7, 1);
			return pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터 베이스 오류	
	}
	
	public boolean nextPage(int commentNumber, String bbs, int bbsID) {
		String SQL = "SELECT * FROM COMMENT WHERE commentID < ? AND commentAvailable = 1 ORDER BY commentID DESC LIMIT 10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext(bbs, bbsID) - (commentNumber -1) * 10);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return true;
			}

		}catch (Exception e) {
			e.printStackTrace();
		}
		return false; //데이터 베이스 오류	
	}
	
	public int delete(int bbsID, String job, int commentID) {

		String SQL = "UPDATE COMMENT SET commentAvailable = 0 WHERE commentID = ? AND bbsName = ? AND bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setInt(1, commentID);
			pstmt.setString(2, job);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터 베이스 오류	
	}
}
