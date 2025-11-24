package model.utils;

public class PrivacyUtils {
    
    /**
     * Che đi phần giữa của email
     * Ví dụ: luongvanvo29@gmail.com → luong****@gmail.com
     */
    public static String maskEmail(String email) {
        if (email == null || email.isEmpty()) {
            return "N/A";
        }
        
        // Tìm vị trí @ trong email
        int atIndex = email.indexOf("@");
        if (atIndex <= 0) {
            return email; // Email không hợp lệ
        }
        
        String localPart = email.substring(0, atIndex);
        String domainPart = email.substring(atIndex);
        
        // Nếu phần trước @ có ít hơn 4 ký tự thì chỉ che 1 ký tự
        if (localPart.length() <= 3) {
            return localPart.charAt(0) + "***" + domainPart;
        }
        
        // Giữ 2-3 ký tự đầu và 1-2 ký tự cuối, che phần giữa
        int keepStart = Math.min(3, localPart.length() / 3);
        int keepEnd = Math.min(2, localPart.length() / 4);
        
        String start = localPart.substring(0, keepStart);
        String end = localPart.substring(localPart.length() - keepEnd);
        
        return start + "****" + end + domainPart;
    }
    
    /**
     * Che đi phần giữa của số điện thoại
     * Ví dụ: 0987652123 → 09*****123
     */
    public static String maskPhone(String phone) {
        if (phone == null || phone.isEmpty()) {
            return "N/A";
        }
        
        // Loại bỏ các ký tự không phải số
        String cleanPhone = phone.replaceAll("[^0-9]", "");
        
        if (cleanPhone.length() < 6) {
            return phone; // Số điện thoại quá ngắn
        }
        
        // Giữ 2-3 số đầu và 2-3 số cuối
        int length = cleanPhone.length();
        int keepStart = (length >= 10) ? 3 : 2; // Nếu >= 10 số thì giữ 3 số đầu
        int keepEnd = (length >= 10) ? 3 : 2;   // Nếu >= 10 số thì giữ 3 số cuối
        
        String start = cleanPhone.substring(0, keepStart);
        String end = cleanPhone.substring(length - keepEnd);
        
        // Tạo chuỗi * với độ dài phù hợp
        int maskedLength = length - keepStart - keepEnd;
        String masked = "*".repeat(Math.max(3, maskedLength));
        
        return start + masked + end;
    }    
}