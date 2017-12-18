//dashboard
  function checkLogin(){
  var auth_token = parseLocalStorage("auth_token");
if (!auth_token)
  window.location.href="<%= request.base_url %>/admin";
/*else
  $("#loginCheckLoader").fadeOut(1000);*/
}
checkLogin();

function parseLocalStorage(key) {
return localStorage[key] ? localStorage[key] : false;
}


function remote(url,data,method,successCallback){
	 $("#loginCheckLoader").fadeIn(100);
$.ajax({
	url:base_url+"/"+url,
	 headers: {
        'Authorization':'Bearer '+parseLocalStorage('auth_token'),
    },
	data:data,
	type:method,
	success:function(response){
		 $("#loginCheckLoader").fadeOut(100);
successCallback(response);

	},
	failure:function(error){
		alert(JSON.stringify(error))
	}
})
}


/*var varGroups=[
groups:{
	url=''
}
];


$(document).ready(function(){
auth_token= parseLocalStorage("auth_token");

});*/