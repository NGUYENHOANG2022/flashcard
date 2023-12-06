<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page import="com.prj.assignment301.utils.Constants"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%
	pageContext.setAttribute("user", session.getAttribute(Constants.SESSION_USER));
	pageContext.setAttribute("contactPath", request.getContextPath() + AppPaths.CONTACT);
%>
<jsp:useBean id="user" class="com.prj.assignment301.model.User" scope="page" />

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Flashcard - Contact us</title>
		<tag:head alpine="true" icon="true" cssPath="/assets/css/index.css" contextPath="${pageContext.request.contextPath}" />
  </head>
  <body>
    <!-- Navbar -->
    <jsp:include page="WEB-INF/jspf/navbar.jsp" flush="true" />

    <!-- Contact form -->
    <div class="relative flex items-center justify-center py-12 px-6 flex-1">
      <div class="bg-white w-full max-w-xl mx-auto p-8 rounded-lg shadow-md">
        <h2 class="text-2xl font-bold mb-4 text-center">Contact us</h2>
        <div class="border-t border-gray-300 my-2"></div>
        <div class="italic text-center w-full my-6">
          <p>Looks like you need support from us.</p>
          <p>
            Our team will contact you as soon as we receive your information.
          </p>
        </div>
        <form class="space-y-6" method="POST" action="${pageScope.contactPath}">
          <div class="flex items-center">
            <label class="block text-gray-700 font-bold mr-2" for="email">
              Your email
            </label>
            <input
              class="appearance-none border rounded flex-1 py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600 read-only:bg-gray-100 read-only:focus:ring-1 read-only:focus:ring-gray-300"
              id="email"
              name="email"
              type="email"
              placeholder="Enter your email"
							required
							value="${user.email}"
							${not empty user.email ? 'readonly' : ''}
							/>
          </div>
          <div class="flex items-center">
            <label class="block text-gray-700 font-bold mr-2 w-max" for="name">
              Your name
            </label>
            <input
              class="appearance-none border rounded flex-1 py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600 read-only:bg-gray-100 read-only:focus:ring-1 read-only:focus:ring-gray-300"
              id="name"
              name="name"
              type="text"
              placeholder="Enter your name"
							required
							value="${user.name}"
							${not empty user.name ? 'readonly' : ''}
							/>
          </div>
          <div>
            <label class="block text-gray-700 font-bold mb-2" for="message">
              Message
            </label>
            <textarea
              class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600"
              id="message"
              name="message"
              rows="4"
              cols="50"
              placeholder="Type something..."
							required
							></textarea>
          </div>

          <div class="flex justify-end">
            <button
              class="bg-indigo-600 hover:bg-indigo-500 text-white font-bold py-2 px-4 rounded focus:shadow-outline"
              type="submit"
							>
              Send
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Footer -->
    <jsp:include page="WEB-INF/jspf/footer.jsp" flush="true" />
    <jsp:include page="WEB-INF/jspf/notification.jsp" flush="true" />
  </body>
</html>
