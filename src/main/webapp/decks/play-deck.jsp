<%-- 
    Document   : play-deck
    Created on : Apr 23, 2023, 6:42:32 PM
    Author     : Admin
--%>

<%@page import="com.prj.assignment301.utils.Constants"%>
<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>
<%
	pageContext.setAttribute("user", session.getAttribute(Constants.SESSION_USER));
	pageContext.setAttribute("apiPath", request.getContextPath() + AppPaths.PLAY_DECK + "?id=" + request.getParameter("id") + "&user_id=");
	pageContext.setAttribute("homePath", request.getContextPath() + AppPaths.HOME);
%>
<jsp:useBean id="user" class="com.prj.assignment301.model.User" scope="page" />

<!DOCTYPE html>
<html>
	<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>Flashcard - Play deck</title>
		<tag:head alpine="true" icon="true" cssPath="/assets/css/index.css" contextPath="${pageContext.request.contextPath}" />
    <script type="module" crossorigin src="/prj301-block3/assets/solid/main.js"></script>
    <link rel="stylesheet" href="/prj301-block3/assets/solid/index.css">
	</head>
	<body>
		<input id="apiPath" required hidden value="" data-path="${pageScope.apiPath}${user.userId}" />
		<input id="homePath" required hidden value="" data-path="${pageScope.homePath}" />
		<input id="deckName" required hidden value="" data-value="${requestScope.deckName}" />
		<jsp:include page="../WEB-INF/jspf/navbar.jsp" flush="true"/>
		<div class="container py-8 md:py-12 px-6 mx-auto flex-1">
			<main class="max-w-5xl mx-auto p-6 pt-0"><div id="root"></div></main>
		</div>
		<jsp:include page="../WEB-INF/jspf/footer.jsp" flush="true"/>
	</body>
</html>
