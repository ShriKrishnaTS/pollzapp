function checkLoginStatus() {
    if (localStorage['loggedInUser'])
        window.location.href = 'index.php'

}

checkLoginStatus();
function loginFormSubmit() {
    var formData = $("#login-form").serializeArray();
    $.post(base_url + '/login', formData, function (response) {
        console.log(response);
    }, function (error) {
        console.log(error);
    })

}
