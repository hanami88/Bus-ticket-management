package model.utils;
import java.util.Properties;
import java.util.Random;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtils {
    // HARDCODE - Đơn giản và ổn định
    private static final String FROM_EMAIL = "luongvanvo10@gmail.com";
    private static final String FROM_PASSWORD = "gvfabqtrrzsisrpy";

    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); 
        return String.valueOf(otp);
    }

    public static boolean sendOTP(String toEmail, String otp) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

            Authenticator auth = new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
                }
            };

            Session session = Session.getInstance(props, auth);
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã OTP đặt lại mật khẩu - Hệ thống đặt vé xe");

            String htmlContent = String.format(
                "<html><body>" +
                "<h2>🚌 Hệ thống đặt vé xe</h2>" +
                "<p>Xin chào,</p>" +
                "<p>Bạn đã yêu cầu đặt lại mật khẩu. Mã OTP của bạn là:</p>" +
                "<h1 style='color: #4CAF50; font-size: 36px; text-align: center; background: #f0f0f0; padding: 20px; border-radius: 10px;'>%s</h1>" +
                "<p><strong>Lưu ý:</strong> Mã OTP này có hiệu lực trong 5 phút.</p>" +
                "<p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>" +
                "<hr>" +
                "<p><small>Email này được gửi tự động, vui lòng không trả lời.</small></p>" +
                "</body></html>", otp
            );

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            
            return true;

        } catch (Exception e) {
            System.err.println("EMAIL ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Gửi email thông báo đặt vé thành công
     */
    public static boolean sendBookingConfirmation(String toEmail, String customerName, 
            String tuNoi, String denNoi, String gioKhoiHanh, int soLuong, 
            String tongTien, String bienSoXe, String ngayDat) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

            Authenticator auth = new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
                }
            };

            Session session = Session.getInstance(props, auth);
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("🎫 Xác nhận đặt vé thành công - Hệ thống đặt vé xe");

            String htmlContent = String.format(
                "<html><body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>" +
                "<div style='max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 10px; overflow: hidden;'>" +
                
                "<!-- Header -->" +
                "<div style='background: #5cb85c; color: white; padding: 20px; text-align: center;'>" +
                "<h1 style='margin: 0; font-size: 24px;'>🚌 Xác nhận đặt vé thành công</h1>" +
                "</div>" +
                
                "<!-- Content -->" +
                "<div style='padding: 30px;'>" +
                "<p style='font-size: 16px; margin-bottom: 20px;'>Xin chào <strong>%s</strong>,</p>" +
                "<p style='margin-bottom: 30px;'>Cảm ơn bạn đã sử dụng dịch vụ đặt vé xe của chúng tôi. Vé của bạn đã được đặt thành công!</p>" +
                
                "<!-- Ticket Info -->" +
                "<div style='background: #f8f9fa; border-radius: 10px; padding: 25px; margin: 20px 0; border-left: 4px solid #5cb85c;'>" +
                "<h2 style='color: #5cb85c; margin-top: 0; font-size: 20px; margin-bottom: 20px;'>📋 Thông tin vé xe</h2>" +
                
                "<table style='width: 100%%; border-collapse: collapse;'>" +
                "<tr><td style='padding: 8px 0; font-weight: bold; width: 140px;'>🗺️ Tuyến đường:</td><td style='padding: 8px 0;'>%s → %s</td></tr>" +
                "<tr><td style='padding: 8px 0; font-weight: bold;'>🕐 Giờ khởi hành:</td><td style='padding: 8px 0;'>%s</td></tr>" +
                "<tr><td style='padding: 8px 0; font-weight: bold;'>🚌 Biển số xe:</td><td style='padding: 8px 0;'>%s</td></tr>" +
                "<tr><td style='padding: 8px 0; font-weight: bold;'>🎫 Số lượng vé:</td><td style='padding: 8px 0;'>%d vé</td></tr>" +
                "<tr><td style='padding: 8px 0; font-weight: bold;'>💰 Tổng tiền:</td><td style='padding: 8px 0; color: #e74c3c; font-size: 18px; font-weight: bold;'>%s VNĐ</td></tr>" +
                "<tr><td style='padding: 8px 0; font-weight: bold;'>📅 Ngày đặt:</td><td style='padding: 8px 0;'>%s</td></tr>" +
                "</table>" +
                "</div>" +
                
                "<!-- Important Notes -->" +
                "<div style='background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 8px; padding: 15px; margin: 20px 0;'>" +
                "<h3 style='color: #856404; margin-top: 0; font-size: 16px;'>⚠️ Lưu ý quan trọng:</h3>" +
                "<ul style='margin: 10px 0; padding-left: 20px; color: #856404;'>" +
                "<li>Vui lòng có mặt tại bến xe ít nhất 15 phút trước giờ khởi hành</li>" +
                "<li>Mang theo CMND/CCCD để đối chiếu thông tin</li>" +
                "<li>Giữ email này để làm vé lên xe</li>" +
                "<li>Liên hệ hotline nếu cần hỗ trợ: 1900-1234</li>" +
                "</ul>" +
                "</div>" +
                
                "<!-- Contact -->" +
                "<div style='text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;'>" +
                "<p style='margin: 10px 0; color: #666;'>Chúc bạn có chuyến đi an toàn và vui vẻ! 🌟</p>" +
                "<p style='margin: 10px 0; color: #666;'>Đội ngũ hỗ trợ khách hàng</p>" +
                "</div>" +
                "</div>" +
                
                "<!-- Footer -->" +
                "<div style='background: #f8f9fa; padding: 15px; text-align: center; border-top: 1px solid #eee;'>" +
                "<p style='margin: 0; font-size: 12px; color: #888;'>Email này được gửi tự động, vui lòng không trả lời.</p>" +
                "<p style='margin: 5px 0 0 0; font-size: 12px; color: #888;'>© 2024 Hệ thống đặt vé xe - All rights reserved</p>" +
                "</div>" +
                
                "</div>" +
                "</body></html>", 
                customerName, tuNoi, denNoi, gioKhoiHanh, bienSoXe, soLuong, tongTien, ngayDat
            );

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            
            return true;

        } catch (Exception e) {
            System.err.println("EMAIL BOOKING CONFIRMATION ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}