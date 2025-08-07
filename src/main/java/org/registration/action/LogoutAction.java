package org.registration.action;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.ServletActionContext;
import javax.servlet.http.HttpSession;

public class LogoutAction extends ActionSupport {
    @Override
    public String execute() {
        HttpSession session = ServletActionContext.getRequest().getSession(false);
        if (session != null) {
            session.invalidate(); // destroy session
        }
        return SUCCESS;
    }
}
