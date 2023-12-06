<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%
	if (request.getAttribute("decks") == null) {
		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
		rd.forward(request, response);
	}

	pageContext.setAttribute("deckDetailsPath", request.getContextPath() + AppPaths.DECK_DETAILS + "?id=");
	pageContext.setAttribute("userDetailsPath", request.getContextPath() + AppPaths.USER_DETAILS + "?email=");
%>
<jsp:useBean id="user" class="com.prj.assignment301.model.User" scope="request" />

<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FlashCard - User details</title>
    <tag:head
      alpine="true"
      icon="true"
      cssPath="/assets/css/index.css"
      contextPath="${pageContext.request.contextPath}"
			/>
  </head>
  <body>
    <!-- Navbar -->
    <jsp:include page="../WEB-INF/jspf/navbar.jsp" flush="true" />

    <!-- Main -->
    <div class="container py-8 md:py-12 px-6 mx-auto flex-1">
      <div class="max-w-5xl mx-auto p-6 pt-0">
        <!-- User's info -->
        <div class="grid place-items-center">
          <div class="flex items-center border rounded-lg p-4 shadow-sm bg-white w-max space-x-4">
            <img
              class="h-28 w-28 bg-gray-400 rounded-full mx-auto"
              src="${user.avatar}"
              alt="Profile Image"
							/>
            <div class="text-xl">
              <div class="font-bold">${user.name}</div>
              <div class="text-gray-600 text-lg truncate">${user.email}</div>
            </div>
          </div>
        </div>

        <div class="border-t border-gray-300 my-7"></div>
        <!-- User's decks -->

				<div class="font-bold text-xl mb-2">${user.name}'s public decks (${requestScope.decks.size()})</div>
				<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mt-4">

					<c:forEach items="${requestScope.decks}" var="deck">
						<tag:deck deck="${deck}" href="${pageScope.deckDetailsPath}${deck.deckId}" userDetailPath="${pageScope.userDetailsPath}${deck.ownerEmail}" />
					</c:forEach>

				</div>
      </div>
    </div>

    <!-- Footer -->
    <jsp:include page="../WEB-INF/jspf/footer.jsp" flush="true" />
    <jsp:include page="../WEB-INF/jspf/notification.jsp" flush="true" />

    <script>
			document.addEventListener("alpine:init", () => {
				Alpine.data("userDetails", () => ({

					}));
			});
    </script>
  </body>
</html>
