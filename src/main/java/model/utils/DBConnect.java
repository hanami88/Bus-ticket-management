package model.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {
    private static String DB_URL = "jdbc:mysql://localhost:3306/DatVeXe";
    private static String USERNAME = "root";
    private static String PASSWORD = "12345678";
    private static Connection connection = null;

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(DB_URL, USERNAME, PASSWORD);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return connection;
    }
}
