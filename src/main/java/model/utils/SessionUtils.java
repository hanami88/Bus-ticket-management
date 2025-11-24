package model.utils;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SessionUtils {
    
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
            return isLoggedIn != null && isLoggedIn;
        }
        return false;
    }
    
    public static String getLoggedInUsername(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && isLoggedIn(request)) {
            return (String) session.getAttribute("email");
        }
        return null;
    }
    
    public static long getLoginTime(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && isLoggedIn(request)) {
            Long loginTime = (Long) session.getAttribute("loginTime");
            return loginTime != null ? loginTime : 0;
        }
        return 0;
    }
    
    public static boolean requireLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        if (!isLoggedIn(request)) {
            response.sendRedirect("dangNhapServlet?loginRequired=true");
            return false;
        }
        return true;
    }
    
    public static void setUserInfo(HttpServletRequest request) {
        if (isLoggedIn(request)) {
            String username = getLoggedInUsername(request);
            long loginTime = getLoginTime(request);
            
            request.setAttribute("currentUsername", username);
            request.setAttribute("loginTime", new java.util.Date(loginTime));
            request.setAttribute("isUserLoggedIn", true);
        }
    }

    public static void logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("isLoggedIn");
            session.removeAttribute("email");
            session.removeAttribute("loginTime");
            
            session.invalidate();
        }
        
        javax.servlet.http.Cookie cookie = new javax.servlet.http.Cookie("JSESSIONID", null);
        cookie.setMaxAge(0);
        cookie.setPath(request.getContextPath());
        response.addCookie(cookie);
    }

    public static boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && isLoggedIn(request)) {
            Integer role = (Integer) session.getAttribute("role");
            return role != null && role == 2;
        }
        return false;
    }
}