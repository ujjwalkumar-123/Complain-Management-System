package org.registration.action;

import com.opensymphony.xwork2.ActionSupport;
import org.registration.model.User;

public class FormAction extends ActionSupport {

    private static final long serialVersionUID = 1L;

    private User user;
    private UserService userService;

    // Dependency Injection
    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    @Override
    public String execute() {
        try {
            // Basic validation
            if (user == null || isEmpty(user.getFirstName()) || isEmpty(user.getEmail()) || isEmpty(user.getPassword())) {
                addActionError("Please fill all required fields.");
                return INPUT;
            }

            // Save user
            boolean saved = userService.saveUser(user);

            if (saved) {
                // Success message for login.jsp
                addActionMessage("Registration successful! Please login.");
                return SUCCESS;
            } else {
                addActionError("Registration failed. Please try again.");
                return ERROR;
            }
        } catch (Exception e) {
            addActionError("Error: " + e.getMessage());
            e.printStackTrace();
            return ERROR;
        }
    }

    // Helper method for empty check
    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}
