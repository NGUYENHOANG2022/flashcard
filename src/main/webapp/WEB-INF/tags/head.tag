<%-- 
    Document   : head
    Created on : Mar 9, 2023, 10:09:26 AM
    Author     : Admin
--%>

<%@tag description="Head for pages" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="icon"%>
<%@attribute name="alpine"%>
<%@attribute name="cssPath"%>
<%@attribute name="contextPath"%>

<%-- any content can be specified here e.g.: --%>

<c:if test="${not empty cssPath}">
	<link rel="stylesheet" href="${contextPath}${cssPath}" />
</c:if>
<c:if test="${not empty alpine}">
	<script
		src="https://cdn.jsdelivr.net/npm/alpinejs@3.11.1/dist/cdn.min.js"
		defer
	></script>
</c:if>
<c:if test="${not empty icon}">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" 
				integrity="sha512-SzlrxWUlpfuzQ+pcUCosxcglQRNAq/DZjVsC0lE40xsADsfeQoEypE+enwcOiGjk/bSuGGKHEyjSoQ1zVisanQ==" 
				crossorigin="anonymous" referrerpolicy="no-referrer" />
</c:if>