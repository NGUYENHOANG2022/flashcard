<%-- 
    Document   : deck
    Created on : Mar 10, 2023, 1:31:06 PM
    Author     : Admin
--%>

<%@tag description="A card display simple deck's info" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="deck" type="com.prj.assignment301.model.Deck"%>
<%@attribute name="href"%>
<%@attribute name="userDetailPath"%>
<%@attribute name="curUserId" type="Integer"%>

<%-- any content can be specified here e.g.: --%>
<div class="bg-white rounded-lg shadow-md flex flex-row items-center overflow-hidden">
	<div class="p-4 w-full">
		<a class="block text-xl font-medium text-gray-800 mb-2 truncate" href="${href}" title="${deck.description}" x-html="highlight('${deck.name}')">${deck.name}</a>
		<p class="text-gray-500 text-sm mb-4 truncate">${deck.cardCount} cards</p>
		<div class="flex justify-between">
			<div class="flex items-center space-x-2">
				<c:if test="${empty deck.ownerAvatar}">
					<div class="h-8 w-8 bg-gray-400 rounded-full mx-auto bg-gray-400 flex justify-center items-center">
						<i class="fa-solid fa-user"></i>
					</div>
				</c:if>
				<c:if test="${not empty deck.ownerAvatar}">
					<img
						class="h-8 w-8 bg-gray-400 rounded-full mx-auto"
						src="${deck.ownerAvatar}"
						alt="Profile Image"
						/>
				</c:if>
				<div class="text-lg">
					<a class="font-medium cursor-pointer" href="${userDetailPath}">${not empty deck.ownerName ? deck.ownerId eq curUserId? "You": deck.ownerName : "Unknown"}</a>
				</div>
			</div>
			<div class="text-lg flex items-center" title="${deck.privateDeck == 0 ? 'Public' : 'Private'}">
				<c:if test="${deck.privateDeck == 0}">
					<i class="fa-solid fa-bookmark"></i>
				</c:if>
				<c:if test="${deck.privateDeck != 0}">
					<i class="fa-solid fa-lock"></i>
				</c:if>
			</div>
		</div>
	</div>
</div>