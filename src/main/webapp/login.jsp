<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%
	String signUpPath = request.getContextPath() + AppPaths.SIGNUP;
	String loginPath = request.getContextPath() + AppPaths.LOGIN;
%>

<jsp:useBean id="ERRORS" class="com.prj.assignment301.javabean.LoginErrors" scope="request"/>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Flashcard - Log in</title>
		<tag:head alpine="true" icon="false" cssPath="/assets/css/index.css" contextPath="${pageContext.request.contextPath}" />
  </head>
  <body>
    <!-- Navbar -->
    <jsp:include page="WEB-INF/jspf/navbar.jsp" flush="true" />

    <!-- Login form -->
    <div class="flex items-center justify-center py-12 px-6 flex-1">
      <div
        class="bg-white w-full max-w-xs mx-auto p-8 rounded-lg shadow-md"
        x-data="loginForm"
				>
        <h2 class="text-2xl font-bold mb-4 text-center">Log In</h2>
        <form class="space-y-6" action="<%= loginPath%>" method="POST">
          <div>
            <label class="block text-gray-700 font-bold mb-2" for="email">
              Email
            </label>
            <input
              class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600"
              x-bind:class="{ 'border-red-500': errors.email }"
              id="email"
              type="email"
              name="email"
							value="${ERRORS.email}"
              placeholder="Enter your email"
              x-on:input="errors.email = ''"
							/>
            <p
              x-show="errors.email"
              class="text-red-700"
              x-text="errors.email"
							></p>
          </div>
          <div>
            <label class="block text-gray-700 font-bold mb-2" for="password">
              Password
            </label>
            <input
              class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600"
              x-bind:class="{ 'border-red-500': errors.password }"
              id="password"
              name="password"
              type="password"
              placeholder="Enter your password"
              x-on:input="errors.password = ''"
							/>
            <p
              x-show="errors.password"
              class="text-red-700"
              x-text="errors.password"
							></p>
          </div>
          <div>
            <button
              class="bg-indigo-600 hover:bg-indigo-500 text-white font-bold py-2 px-4 rounded focus:shadow-outline w-full"
              type="submit"
							>
              Log In
            </button>
          </div>
          <div class="text-center text-sm text-gray-500 mt-4">
            Don't have an account?
            <a
              class="font-bold text-indigo-600 hover:text-indigo-500"
              href="<%= signUpPath%>"
              >Sign up</a
            >
          </div>
        </form>
      </div>
    </div>

    <!-- Footer -->
    <jsp:include page="WEB-INF/jspf/footer.jsp" flush="true" />
    <jsp:include page="WEB-INF/jspf/notification.jsp" flush="true" />

    <script>
			document.addEventListener("alpine:init", () => {
				Alpine.data("loginForm", () => ({
						init() {
							this.errors = {
								email: '${ERRORS.emailErrs}',
								password: '${ERRORS.passwordErrs}'
							};
						},
						errors: {}
					}));
			});
    </script>
  </body>
</html>
