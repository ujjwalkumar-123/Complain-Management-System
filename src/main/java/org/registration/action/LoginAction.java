package org.registration.action;

import com.opensymphony.xwork2.ActionSupport;
import org.registration.model.User;
import org.apache.struts2.ServletActionContext;
import javax.servlet.http.HttpSession;

public class LoginAction extends ActionSupport {

    private String email;
    private String password;
    private UserService userService;

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    @Override
    public String execute() {
        if (isEmpty(email)) {
            addActionError("Email is required.");
            return INPUT;
        }
        if (isEmpty(password)) {
            addActionError("Password is required.");
            return INPUT;
        }

        User user = userService.validateUser(email.trim(), password.trim());

        if (user != null) {
            HttpSession session = ServletActionContext.getRequest().getSession();
            session.setAttribute("userName", user.getFirstName());
            session.setAttribute("role", user.getRole());

            if ("admin".equalsIgnoreCase(user.getRole())) {
                return "admin"; // Redirect to adminComplaintList
            } else {
                return "user"; // Redirect to complaintList
            }
        } else {
            addActionError("Invalid email or password.");
            return INPUT;
        }
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
