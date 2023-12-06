package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.UserDAO;
import com.prj.assignment301.javabean.Notification;
import com.prj.assignment301.javabean.SignUpErrors;
import com.prj.assignment301.utils.AppPaths;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
public class SignUpServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
					throws ServletException, IOException {
		String email = request.getParameter("email");
		String name = request.getParameter("name");
		String password = request.getParameter("password");
		String rePassword = request.getParameter("re-enterpassword");

		SignUpErrors errors = new SignUpErrors();
		boolean hasErrors = false;

// Validate email
		if (email == null || email.trim().isEmpty()) {
			errors.setEmailErr("Email is required");
			hasErrors = true;
		} else if (!email.matches("\\w+@[\\w.]+\\.[a-z]{2,}")) {
			errors.setEmailErr("Invalid email format");
			hasErrors = true;
		}
		errors.setEmail(email); // save email for next try

// Validate name
		if (name == null || name.trim().isEmpty()) {
			errors.setNameErr("Name is required");
			hasErrors = true;
		} else {
			errors.setName(name);
		}

// Validate password
		if (password == null || password.trim().isEmpty()) {
			errors.setPasswordErr("Password is required");
			hasErrors = true;
		} else if (password.length() < 6) {
			errors.setPasswordErr("Password must be at least 6 characters long");
			hasErrors = true;
		}

// Validate retyped password
		if (rePassword == null || rePassword.trim().isEmpty()) {
			errors.setRetypePasswordErr("Retype password is required");
			hasErrors = true;
		} else if (!rePassword.equals(password)) {
			errors.setRetypePasswordErr("Passwords do not match");
			hasErrors = true;
		}

		if (hasErrors) {
			request.setAttribute("ERRORS", errors);
			request.getRequestDispatcher(AppPaths.SIGNUP_JSP).forward(request, response);
			return;
		}

		UserDAO userDao = new UserDAO();
		boolean userExists = userDao.isUserExist(email);

		if (!userExists) {
			boolean success = userDao.addUser(email, password, name);

			if (success) {
				response.sendRedirect(request.getContextPath() + AppPaths.LOGIN + "?success=Sign up successfully");
				return;
			} else {
				Notification n = new Notification("Error", "Something went wrong. Please try again", "error");
				request.setAttribute("notification", n);
			}
		} else {
			errors.setEmailErr("User with this email already exists");
			request.setAttribute("ERRORS", errors);
		}

		request.getRequestDispatcher(AppPaths.SIGNUP_JSP).forward(request, response);
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.SIGNUP_JSP);
		rd.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		processRequest(request, response);
	}

	@Override
	public String getServletInfo() {
		return "Sign up";
	}// </editor-fold>

}
