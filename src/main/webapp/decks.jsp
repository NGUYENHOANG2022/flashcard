<%-- 
    Document   : home
    Created on : Apr 25, 2023, 12:19:22 PM
    Author     : Admin
--%>

<%@page import="com.prj.assignment301.utils.Constants"%>
<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%
	if (request.getAttribute("decks") == null
					&& request.getAttribute("recentDecks") == null
					&& request.getRequestURI().endsWith(".jsp")) {

		String requestedUrl = request.getRequestURI() + "?" + request.getQueryString();
		// Remove the '.jsp' part from the URL using a regex
		requestedUrl = requestedUrl.replaceAll("\\.jsp([?&].*)?$", "$1");
		// Send the client to the modified URL
		response.sendRedirect(requestedUrl);
	}

	pageContext.setAttribute("deckDetailsPath", request.getContextPath() + AppPaths.DECK_DETAILS + "?id=");
	pageContext.setAttribute("userDetailsPath", request.getContextPath() + AppPaths.USER_DETAILS + "?email=");
	pageContext.setAttribute("searchPath", request.getContextPath() + AppPaths.HOME);
	pageContext.setAttribute("createDeckPath", request.getContextPath() + AppPaths.CREATE_DECK);
	pageContext.setAttribute("user", session.getAttribute(Constants.SESSION_USER));
%>

<!DOCTYPE html>
<html lang="en">
	<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>FlashCard - Decks</title>
		<tag:head alpine="true" icon="true" cssPath="/assets/css/index.css" contextPath="${pageContext.request.contextPath}" />
	</head>
	<body>
		<jsp:include page="WEB-INF/jspf/navbar.jsp" flush="true"/>

		<div class="container py-8 md:py-12 px-6 mx-auto flex-1" x-data="decksPage">
			<main class="max-w-5xl mx-auto p-6 pt-0">
				<form action="${pageScope.searchPath}" method="GET">
					<div class="flex justify-center">
						<div class="relative">
							<input type="text" 
										 class="w-96 max-w-full border-gray-300 rounded-full py-2 px-4 leading-tight pl-12 border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600" 
										 placeholder="Search decks (type text, then press Enter)" 
										 name="search"
										 value="${requestScope.search}"
										 >
							<button class="absolute inset-y-0 left-0 flex items-center pl-4" type="submit" title="Search">
								<i class="fa-solid fa-magnifying-glass"></i>
							</button>
						</div>
					</div>
					<c:if test="${not empty pageScope.user}">
						<div class="flex items-center justify-center gap-4 mt-2">
							<div class="inline-flex gap-2">
								<input type="checkbox" id="otherDeck" value="true" name="od" x-bind:checked="othersDecks" />
								<label for="otherDeck">Search others' public decks</label>
							</div>
							<a href="${pageScope.createDeckPath}" class="text-indigo-600 font-semibold hover:text-indigo-500 hover:underline hover:underline-offset-2">Create new deck</a>
						</div>
					</c:if>
				</form>

				<%-- User not login --%>
				<c:if test="${empty pageScope.user or requestScope.othersDecks == true}">
					<div class="font-bold text-xl mb-2 mt-10">Public decks</div>
					<c:if test="${requestScope.decks.size() > 0}">
						<div class="w-full grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mt-4">
							<c:forEach items="${requestScope.decks}" var="deck">
								<tag:deck deck="${deck}" href="${pageScope.deckDetailsPath}${deck.deckId}" userDetailPath="${pageScope.userDetailsPath}${deck.ownerEmail}" curUserId="${pageScope.user.userId}"/>
							</c:forEach>
						</div>
					</c:if>
					<c:if test="${requestScope.decks.size() <= 0 || empty requestScope.decks}">
						<p class="text-center my-4 text-base leading-7 text-gray-600">No public decks found</p>
					</c:if>
				</c:if>

				<%-- User logged in --%>
				<c:if test="${not empty pageScope.user and requestScope.othersDecks == false}">
					<c:if test="${empty requestScope.search}">
						<div class="font-bold text-xl mb-2 mt-10">Recent</div>
						<c:if test="${requestScope.recentDecks.size() > 0}">
							<div class="w-full grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mt-4">
								<c:forEach begin="0" end="2" items="${requestScope.recentDecks}" var="deck">
									<tag:deck deck="${deck}" href="${pageScope.deckDetailsPath}${deck.deckId}" userDetailPath="${pageScope.userDetailsPath}${deck.ownerEmail}" curUserId="${pageScope.user.userId}"/>
								</c:forEach>
							</div>
						</c:if>
						<c:if test="${requestScope.recentDecks.size() <= 0 || empty requestScope.recentDecks}">
							<p class="text-center my-4 text-base leading-7 text-gray-600">No recent decks found</p>
						</c:if>
					</c:if>

					<div class="font-bold text-xl mb-2 mt-10">Your decks (${requestScope.decks.size()})</div>
					<c:if test="${requestScope.decks.size() > 0}">
						<div class="w-full grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mt-4">
							<c:forEach items="${requestScope.decks}" var="deck">
								<tag:deck deck="${deck}" href="${pageScope.deckDetailsPath}${deck.deckId}" userDetailPath="${pageScope.userDetailsPath}${deck.ownerEmail}" curUserId="${pageScope.user.userId}"/>
							</c:forEach>
						</div>
					</c:if>
					<c:if test="${requestScope.decks.size() <= 0 || empty requestScope.decks}">
						<p class="text-center my-4 text-base leading-7 text-gray-600">No decks found</p>
					</c:if>
				</c:if>
			</main>
		</div>

		<jsp:include page="WEB-INF/jspf/footer.jsp" flush="true"/>
		<jsp:include page="WEB-INF/jspf/notification.jsp" flush="true"/>

    <script>
			document.addEventListener("alpine:init", () => {
				function highlight(text) {
					if (!text || !this.search.trim())
						return text;
					const p = this.search.trim().replace(/[-/\\^$*+?.()|[\]{}]/g, '\\$&');
					const re = new RegExp(`(${"${"}p})`, 'gi');
					return text.replace(re, '<span class="bg-yellow-200">$1</span>');
				}

				Alpine.data("decksPage", () => ({
						search: '${requestScope.search}',
						othersDecks: ${requestScope.othersDecks},
						highlight
					}));
			});
    </script>
	</body>
</html>
