package org.registration.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateCleanupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Hibernate SessionFactory initialize
        SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();
        sce.getServletContext().setAttribute("SessionFactory", sessionFactory);
        System.out.println("Hibernate SessionFactory initialized");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Hibernate SessionFactory close
        SessionFactory sessionFactory = (SessionFactory) sce.getServletContext().getAttribute("SessionFactory");
        if (sessionFactory != null) {
            sessionFactory.close();
            System.out.println("Hibernate SessionFactory closed");
        }
    }
}
