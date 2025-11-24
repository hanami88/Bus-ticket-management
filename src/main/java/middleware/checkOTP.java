package middleware;

public class checkOTP {
    public static boolean isValidOTP(String otp) {
        if (otp == null || otp.trim().isEmpty()) {
            return false;
        }
        return true;
    }

    public static boolean isExpiredOTP(long otpTime) {
        if (System.currentTimeMillis() - otpTime > 5 * 60 * 1000) {
            return false; // Mã OTP sẽ hết hạn sau 5 phút
        }
        return true;
    }
}
