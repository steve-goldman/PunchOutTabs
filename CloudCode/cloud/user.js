//
// methods called by users via cloud definitions in main.js
//

// validate the user
exports.validate = function(request, response) {

    const username = request.object.getUsername();

    const USERNAME_MIN_LENGTH = 6;
    const USERNAME_MAX_LENGTH = 20;
    
    if (!username || username.length < USERNAME_MIN_LENGTH || username.length > USERNAME_MAX_LENGTH) {
        response.error("Username must be between " + USERNAME_MIN_LENGTH + " and " + USERNAME_MAX_LENGTH + " characters");
        return;
    }

    const USERNAME_REGEX = /^([a-z]|[A-Z])([a-z]|[A-Z]|[0-9]|_)*$/

    if (!USERNAME_REGEX.test(username)) {
        response.error("Username must begin with a letter and contain only letters, numbers, and underscores");
        return;
    }

    //
    // parse does not support password constraints, must do this in client
    //

    //
    // parse handles email validation (does not give us access to email at this point)
    //

    response.success();
}
