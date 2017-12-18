//login checker

function checkLogin(){
  var auth_token = parseLocalStorage("auth_token");
if (auth_token)
  window.location.href="<%= request.base_url %>/admin/view_groups";
}
checkLogin();
function parseLocalStorage(key) {
return localStorage[key] ? localStorage[key] : false;
}

function ajaxCalls(url,data,callback){
  $.post(url,data,function(response){callback(response)});
}

function otpSent(response){
  console.log(response);
  // response=$.parseJSON(response);
  console.log(response.message);
  if(response.message=='OTP Sent'){
    $("#mobileform").hide();
    $("#otpform").show();
  }else{
    alert('error sending OTP. Try again.')
  }
}

$(document).ready(function(){
$("#mobileSubmit").on("click",function(){
ajaxCalls('<%=request.base_url %>/otp',{phone:$("#exampleInputEmail1").val()},otpSent);
});
$("#otpSubmit").on("click",function(){
var otp=$("#exampleInputPassword2").val();
var phone=$("#exampleInputEmail1").val();
$.ajax({
  url:'<%=request.base_url %>/otp',
  type: 'PUT',
  data:{otp:otp,phone:phone},
  success: function(response) {
    console.log(response);
    if(response.message=="OTP Verified")
      if(typeof response.auth_token!='undefined')
        localStorage.setItem('auth_token',response.auth_token)
      checkLogin();
  },
  failure:function(error){
     console.log(error);
  }
})


// ajaxCalls('<%=request.base_url %>/otp',{phone:$("#exampleInputEmail1").val()},otpSent);
});
});