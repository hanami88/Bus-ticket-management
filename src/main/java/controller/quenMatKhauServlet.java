package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import middleware.checkEmailInput;
import middleware.checkOTP;
import model.bean.User;
import model.bo.authBO;
import model.utils.EmailUtils;


@WebServlet("/quenMatKhauServlet")
public class quenMatKhauServlet extends HttpServlet {
    private final static long serialVersionUID = 1L;
    private final authBO authBO = new authBO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String step = request.getParameter("step");
        if (step == null || step.isEmpty()) {
            step = "1";
        }

        request.setAttribute("step", step);
        request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String step = request.getParameter("step");
        HttpSession session = request.getSession();

        try {
            if ("1".equals(step)) {
                handleEmail(request, response, session);
            } else if ("2".equals(step)) {
                handleOTP(request, response, session);
            } else if ("3".equals(step)) {
                handleNewPassword(request, response, session);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình xử lý. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
            return;
        }
    }

    private void handleEmail(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
        String email = request.getParameter("email");

        if (!checkEmailInput.isValidEmail(email)) {
            request.setAttribute("error", "Email không tồn tại hoặc không hợp lệ");
            request.setAttribute("step", "1");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
            return;
        }

        // Kiểm tra user có tồn tại với email này không 
        User user = authBO.getUserByEmail(email);
        if (user == null) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống");
            request.setAttribute("step", "1");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
            return;
        }

        // Tạo OTP và gửi email 
        String otp = EmailUtils.generateOTP();
        boolean emailSent = EmailUtils.sendOTP(email, otp);

        if (emailSent) {
            // Lưu thông tin vào sesstion
            session.setAttribute("resetEmail", email);
            session.setAttribute("resetOTP", otp);
            session.setAttribute("otpTime", System.currentTimeMillis());

            request.setAttribute("step", "2");
            request.setAttribute("message", "OTP đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư.");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Lỗi khi gửi email. Vui lòng thử lại sau.");
            request.setAttribute("step", "1");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
        }
    }
    
    private void handleOTP(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
        String inputOTP = request.getParameter("otp");
        String sessionOTP = (String) session.getAttribute("resetOTP");
        long otpTime = (Long) session.getAttribute("otpTime");

        if (!checkOTP.isValidOTP(inputOTP)) {
            request.setAttribute("error", "Vui lòng nhập mã OTP!!");
            request.setAttribute("step", "2");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
            return;
        }

        if (!checkOTP.isExpiredOTP(otpTime)) {
            session.removeAttribute("resetOTP");
            session.removeAttribute("otpTime");
            request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng yêu cầu lại.");
            request.setAttribute("step", "1");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
            return;
        }

        if (!inputOTP.equals(sessionOTP)) {
            request.setAttribute("error", "Mã OTP không chính xác. Vui lòng thử lại.");
            request.setAttribute("step", "2");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
            return;
        }

        // Nếu OTP đúng, chuyển sang bước 3
        request.setAttribute("step", "3");
        request.setAttribute("message", "Mã OTP chính xác. Vui lòng nhập mật khẩu mới.");
        request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
    }

    private void handleNewPassword(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = (String) session.getAttribute("resetEmail");

        if (newPassword == null || newPassword.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin mật khẩu mới.");
            request.setAttribute("step", "3");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
            request.setAttribute("step", "3");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
            return;
        }

        boolean isUpdatedPassword = authBO.updatePassword(email, newPassword);
        if (isUpdatedPassword) {
            session.removeAttribute("resetEmail");
            session.removeAttribute("resetOTP");
            session.removeAttribute("otpTime");

            request.setAttribute("success", "Mật khẩu đã được cập nhật thành công.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Lỗi khi cập nhật mật khẩu. Vui lòng thử lại.");
            request.setAttribute("step", "3");
            request.getRequestDispatcher("/quenMatKhau.jsp").forward(request, response);
        }
    }
}
