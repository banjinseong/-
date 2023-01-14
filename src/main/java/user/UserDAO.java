package user;

import java.sql.*;



public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
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
	
	public int login(String userPassword, String userID) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword))
					return 1;//로그인성공
				else 
					return 0; // 비밀번호 불일치
			}
			return -1;//아이디가없음
		}catch (Exception e) {
			e.printStackTrace();
		}
		return -2; //데이터 베이스 오류
	}
	
	public String getjob(String userID) {
		String SQL = "SELECT userJob FROM USER WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next())
				return rs.getString(1);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserNo());
			pstmt.setString(2, user.getUserID());
			pstmt.setString(3, user.getUserPassword());
			pstmt.setString(4, user.getUserName());
			pstmt.setString(5, user.getUserJob());
			return pstmt.executeUpdate();//insert문 실행을 한후에는 반드시 0이상의 수가 반환됨
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1;//데이터베이스오류
	}
}
