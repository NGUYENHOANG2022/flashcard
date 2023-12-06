/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.filter;

import com.prj.assignment301.utils.AppPaths;
import com.prj.assignment301.utils.Constants;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
public class AuthFilter implements Filter {

	/**
	 *
	 * @param request The servlet request we are processing
	 * @param response The servlet response we are creating
	 * @param chain The filter chain we are processing
	 *
	 * @exception IOException if an input/output error occurs
	 * @exception ServletException if a servlet error occurs
	 */
	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
					FilterChain chain)
					throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;

		HttpSession session = httpRequest.getSession(false);

		boolean isUser = (session != null && session.getAttribute(Constants.SESSION_USER) != null);
		boolean isAdmin = (session != null && session.getAttribute(Constants.SESSION_ADMIN) != null);

		if (isUser) {
			httpResponse.sendRedirect(httpRequest.getContextPath() + AppPaths.HOME);
		} else if (isAdmin) {
			httpResponse.sendRedirect(httpRequest.getContextPath() + AppPaths.ADMIN);
		} else {
			chain.doFilter(request, response);
		}
	}

	/**
	 * Destroy method for this filter
	 */
	@Override
	public void destroy() {
	}

	/**
	 * Init method for this filter
	 *
	 * @param filterConfig
	 */
	@Override
	public void init(FilterConfig filterConfig) {

	}

}
