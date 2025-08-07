<%@ page import="org.hibernate.Session"%>
<%@ page import="org.hibernate.SessionFactory"%>
<%@ page import="org.hibernate.Transaction"%>
<%@ page import="org.registration.model.Complaint"%>
<%@ page import="org.registration.util.HibernateUtil"%>

<%
    String idParam = request.getParameter("id");
    if (idParam != null && !idParam.isEmpty()) {
        int id = Integer.parseInt(idParam);

        SessionFactory factory = HibernateUtil.getSessionFactory();
        Session hibSession = null;
        Transaction tx = null;

        try {
            hibSession = factory.openSession();
            tx = hibSession.beginTransaction();

            Complaint complaint = hibSession.get(Complaint.class, id);
            if (complaint != null) {
                hibSession.delete(complaint);
                tx.commit();
                session.setAttribute("successMessage", "Complaint deleted successfully.");
            } else {
                session.setAttribute("errorMessage", "Complaint not found.");
            }

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error while deleting complaint.");
        } finally {
            if (hibSession != null) hibSession.close();
        }
    } else {
        session.setAttribute("errorMessage", "Invalid complaint ID.");
    }

    response.sendRedirect("complaints.jsp");
%>
