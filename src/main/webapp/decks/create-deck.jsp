<%-- 
    Document   : createdeck
    Created on : Mar 6, 2023, 4:21:18 PM
    Author     : hieunghia
--%>

<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%
	pageContext.setAttribute("createDeckPath", request.getContextPath() + AppPaths.CREATE_DECK);
	pageContext.setAttribute("addCardsPath", request.getContextPath() + AppPaths.ADD_CARDS);
%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
		<title>FlashCard - Create deck</title>
		<tag:head
			alpine="true"
			icon="true"
			cssPath="/assets/css/index.css"
			contextPath="${pageContext.request.contextPath}"
			/>
	</head>
	<body>
		<!-- Navbar -->
		<jsp:include page="../WEB-INF/jspf/navbar.jsp" flush="true"/>

		<!-- Create Deck -->
		<div class="relative flex items-center justify-center py-12 px-6 flex-1">
			<div class ="bg-white w-full max-w-xl mx-auto p-8 rounded-lg shadow-md">
				<h2 class="text-2xl font-bold mb-4 text-center">New deck</h2>
				<form class="space-y-6" method="POST" action="${pageScope.createDeckPath}">
					<div class="flex items-center">
						<label class="block text-gray-700 font-bold mr-2" for="name">
							Deck name:
						</label>
						<input 
							class="appearance-none border rounded flex-1 py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600"
							id="name"
							name="name"
							type="text"
							placeholder="Type something..."
							required
							/>                        
					</div>
					<div>
						<label class="block text-gray-700 font-bold mb-2" for="description">
							Description:
						</label>
						<textarea class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600"
											id="descripton"
											name="description"
											rows="6"
											cols="50"
											placeholder="Say something about this deck..."
											></textarea>
					</div>
					<div class="flex">
						<label class="block text-gray-700 font-bold mb-2 mr-4" for="visibility">
							Visibility:
						</label>
						<div class="mr-4">
							<input class="" id="public" name="visibility" type="radio" value="public" checked/>
							<label for="public">Public</label>
						</div>
						<div class="mr-4">
							<input class="" id="private" name="visibility" type="radio" value="private"/>
							<label for="private">Private</label>
						</div>

					</div>
					<div class="flex justify-end items-center gap-x-6">
						<a href="${pageScope.addCardsPath}" class="font-bold text-indigo-600 hover:text-indigo-500 hover:underline hover:underline-offset-2">Add cards</a>
						<button
							class="bg-indigo-600 hover:bg-indigo-500 text-white font-bold py-2 px-4 rounded focus:shadow-outline"
							type="submit">
							Create
						</button>
					</div>
				</form>
			</div>           
		</div>

		<!-- Footer -->
		<jsp:include page="../WEB-INF/jspf/footer.jsp" flush="true"/>
		<jsp:include page="../WEB-INF/jspf/notification.jsp" flush="true"/>
	</body>
</html>
