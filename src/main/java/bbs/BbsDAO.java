package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {
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
	
	public int getNext(String bbs) {
		String SQL = "SELECT bbsID FROM " + bbs + " ORDER BY bbsID DESC";
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
	
	public int write(String bbsTitle, String userID, String bbsContent, String userJob) {
		String bbs = null;
		if(userJob.equals("기계공학부")) {
			bbs = "MCBBS";
		}else if(userJob.equals("정보산업공학부")) {
			bbs = "IFBBS";
		}else if(userJob.equals("컴퓨터정보공학부")) {
			bbs = "CPBBS";
		}else if(userJob.equals("건축학부")) {
			bbs = "CTBBS";
		}else if(userJob.equals("서비스학부")) {
			bbs = "SVBBS";
		}else {
			bbs="BBS";
		}
		String SQL = "INSERT INTO " + bbs + " VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setInt(1, getNext(bbs));
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터 베이스 오류	
	}
	
	public ArrayList<Bbs> getList(int pageNumber, String userJob){
		String SQL = "SELECT * FROM " + userJob + " WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setInt(1, getNext(userJob) - (pageNumber -1) * 10);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}

		}catch (Exception e) {
			e.printStackTrace();
		}
		return list; //데이터 베이스 오류	
	}
	
	public boolean nextPage(int pageNumber, String bbs) {
		String SQL = "SELECT * FROM " + bbs + " WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext(bbs) - (pageNumber -1) * 10);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return true;
			}

		}catch (Exception e) {
			e.printStackTrace();
		}
		return false; //데이터 베이스 오류	
	}
	
	public Bbs getBbs(int bbsID, String userJob) {
		String job = null;
		if(userJob.equals("기계공학부")) {
			job = "MCBBS";
		}else if(userJob.equals("정보산업공학부")) {
			job = "IFBBS";
		}else if(userJob.equals("컴퓨터정보공학부")) {
			job = "CPBBS";
		}else if(userJob.equals("건축학부")) {
			job = "CTBBS";
		}else if(userJob.equals("서비스학부")) {
			job = "SVBBS";
		}else {
			job="BBS";
		}
		String SQL = "SELECT * FROM " + job + " WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs;
			}

		}catch (Exception e) {
			e.printStackTrace();
		}
		return null; //데이터 베이스 오류	
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent, String userJob) {
		String job = null;
		if(userJob.equals("기계공학부")) {
			job = "MCBBS";
		}else if(userJob.equals("정보산업공학부")) {
			job = "IFBBS";
		}else if(userJob.equals("컴퓨터정보공학부")) {
			job = "CPBBS";
		}else if(userJob.equals("건축학부")) {
			job = "CTBBS";
		}else if(userJob.equals("서비스학부")) {
			job = "SVBBS";
		}else {
			job="BBS";
		}
		String SQL = "UPDATE " + job + " SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터 베이스 오류	
	}
	
	public int delete(int bbsID, String userJob) {
		String job = null;
		if(userJob.equals("기계공학부")) {
			job = "MCBBS";
		}else if(userJob.equals("정보산업공학부")) {
			job = "IFBBS";
		}else if(userJob.equals("컴퓨터정보공학부")) {
			job = "CPBBS";
		}else if(userJob.equals("건축학부")) {
			job = "CTBBS";
		}else if(userJob.equals("서비스학부")) {
			job = "SVBBS";
		}else {
			job="BBS";
		}
		String SQL = "UPDATE " + job + " SET bbsAvailable = 0 WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터 베이스 오류	
	}
	
	public ArrayList<Bbs> getSearchList(String userJob, String searchType, String searchText){
		String SQL = "SELECT * FROM " + userJob + " WHERE " + searchType + " = ? AND bbsAvailable = 1 ORDER BY bbsID DESC";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); 
			pstmt.setString(1, searchText);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}

		}catch (Exception e) {
			e.printStackTrace();
		}
		return list; //데이터 베이스 오류	
	}
}
