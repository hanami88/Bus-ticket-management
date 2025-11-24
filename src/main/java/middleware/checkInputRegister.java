package middleware;

public class checkInputRegister {
    public static boolean isValidInputRegister(String name, String email, String password, String phone) {
        if (name == null || email == null || password == null || phone == null ||
            name.isEmpty() || email.isEmpty() || password.isEmpty() || phone.isEmpty()) {
            return false;
        }
        return true;
    }
}
