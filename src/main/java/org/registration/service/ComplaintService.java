package org.registration.service;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.registration.model.Complaint;

public class ComplaintService {

    private SessionFactory sessionFactory;

    public void setSessionFactory(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    // ✅ Fetch all complaints
    public List<Complaint> listComplaints() {
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery("FROM Complaint", Complaint.class).list();
        }
    }

    // ✅ Fetch complaints by user name
    public List<Complaint> listComplaintsByUser(String userName) {
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery("FROM Complaint c WHERE c.userName = :uname", Complaint.class)
                    .setParameter("uname", userName)
                    .list();
        }
    }

    // ✅ Fetch complaint by ID
    public Complaint getComplaintById(int id) {
        try (Session session = sessionFactory.openSession()) {
            return session.get(Complaint.class, id);
        }
    }

    // ✅ Save or update complaint (used for accept/reject/status update)
    public void saveOrUpdateComplaint(Complaint complaint) {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            session.saveOrUpdate(complaint);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ Delete complaint by ID
    public void deleteComplaint(int id) {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            Complaint complaint = session.get(Complaint.class, id);
            if (complaint != null) {
                session.delete(complaint);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ Reset auto-increment if no complaint exists
    public void resetAutoIncrementIfEmpty() {
        Transaction tx = null;
        try (Session session = sessionFactory.openSession()) {
            tx = session.beginTransaction();
            Long count = (Long) session.createQuery("SELECT COUNT(c) FROM Complaint c").uniqueResult();
            if (count == 0) {
                session.createNativeQuery("ALTER TABLE complaints AUTO_INCREMENT = 1").executeUpdate();
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // ✅ For Excel export (distinct complaints)
    public List<Complaint> getDistinctComplaintsForExcel() {
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery("SELECT DISTINCT c FROM Complaint c", Complaint.class).list();
        }
    }
}
