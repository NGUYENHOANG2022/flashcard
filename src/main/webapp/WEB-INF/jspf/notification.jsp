<%-- 
    Document   : notification
    Created on : Mar 4, 2023, 11:26:17 PM
    Author     : Hieu
		NOTE: You need to have a 'notifications' variable in requestScope for this component to work
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.prj.assignment301.javabean.Notification"%>
<%@page import="com.google.gson.Gson"%>
<%
	Gson gson = new Gson();
	Notification noti = (Notification) request.getAttribute("notifications");
	String paramSuccess = request.getParameter("success");
	String paramError = request.getParameter("error");
	List<Notification> notifications = new ArrayList<>();

	if (noti != null) {
		notifications.add(noti);
	}
	if (paramSuccess != null && !paramSuccess.isEmpty()) {
		Notification pSuccess = new Notification("Success", paramSuccess, "success");
		notifications.add(pSuccess);
	}
	if (paramError != null && !paramError.isEmpty()) {
		Notification pError = new Notification("Error", paramError, "error");
		notifications.add(pError);
	}
	pageContext.setAttribute("notiData", gson.toJson(notifications));
%>


<div x-data class="fixed z-50 bottom-0 right-0 m-8">
  <template x-for="(notification, index) in $store.noti.notifications" x-bind:key="index">
    <div x-show="notification.show" 
				 x-transition:enter="transform ease-out duration-300 transition"
         x-transition:enter-start="translate-y-2 opacity-0 sm:translate-y-0 sm:translate-x-2"
         x-transition:enter-end="translate-y-0 opacity-100 sm:translate-x-0"
         x-transition:leave="transition ease-in duration-100"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         class="bg-green-500 text-white font-bold rounded-lg shadow-lg p-4 mb-4 flex items-center justify-between"
         x-bind:class="notification.type === 'error' ? 'bg-red-500' : 'bg-green-500'"
				 x-init="setTimeout(() => notification.show = false, 5000)">
      <div class="flex items-center">
        <div>
          <div class="font-bold" x-text="notification.title"></div>
          <div class="text-sm" x-text="notification.message"></div>
        </div>
      </div>
      <button @click="notification.show = false" class="text-lg font-semibold pl-3">×</button>
    </div>
  </template>
</div>

<script>
	document.addEventListener('alpine:init', () => {

		//String title;
		//String message;
		//String type; // sussess or error
		//boolean show;

		Alpine.store('noti', {
				notifications: [],
				init() {
					let dataString = '${pageScope.notiData}'.trim();
					let data = JSON.parse(dataString);
					if (!data)
						return;
					if (Array.isArray(data)) {
						for (let item of data) {
							this.notifications.push(item);
						}
					} else if (typeof data === 'object') {
						this.notifications.push(data);
					}
				}
			});
	});
</script>