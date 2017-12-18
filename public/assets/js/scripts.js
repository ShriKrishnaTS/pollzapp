function parseLocalStorage(e) {
    return localStorage[loggedInUser + e] ? JSON.parse(localStorage[loggedInUser + e]) : []
}
function deleteLocalStorage(e) {
    return localStorage.removeItem(parseLocalStorage('loggedInUser') + e)
}
function setLocalStorage(key, value) {
    localStorage.setItem(parseLocalStorage('loggedInUser') + key, JSON.stringify(save))
}
function checkLoginStatus() {
    // if (localStorage['loggedInUser'])
        $(".loader-div").fadeOut(500);
    // else
    //     window.location.href = 'login.php'

}
checkLoginStatus();
function loginFormSubmit() {
    var formData = $("#login-form").serializeArray();
    console.log(formData);

    return false;
}
