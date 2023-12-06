<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>
<%
	pageContext.setAttribute("homePage", request.getContextPath() + AppPaths.HOME);
	pageContext.setAttribute("contactPage", request.getContextPath() + AppPaths.CONTACT);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Flashcard - 404</title>
		<tag:head alpine="true" icon="true" cssPath="/assets/css/index.css" contextPath="${pageContext.request.contextPath}" />
	</head>
	<body>
		<jsp:include page="WEB-INF/jspf/navbar.jsp" flush="true"/>

		<div class="container py-12 px-6 mx-auto flex-1">
			<main class="grid max-w-5xl place-items-center mx-auto py-24 px-6 sm:py-32 lg:px-8">
				<div class="text-center">
					<p class="text-base font-semibold text-indigo-600">404</p>
					<h1 class="mt-4 text-3xl font-bold tracking-tight text-gray-900 sm:text-5xl">Page not found</h1>
					<p class="mt-6 text-base leading-7 text-gray-600">Sorry, we couldn’t find the page you’re looking for.</p>
					<div class="mt-10 flex items-center justify-center gap-x-6">
						<a href="${pageScope.homePage}" class="rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Go back home</a>
						<a href="${pageScope.contactPage}" class="text-sm font-semibold text-gray-900">Contact support <span aria-hidden="true">&rarr;</span></a>
					</div>
				</div>
			</main>
		</div>

		<jsp:include page="WEB-INF/jspf/footer.jsp" flush="true"/>
		<jsp:include page="WEB-INF/jspf/notification.jsp" flush="true"/>
	</body>
</html>
