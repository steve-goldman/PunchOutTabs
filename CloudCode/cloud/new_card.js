//
// methods called by users via cloud definitions in main.js
//


// user has pressed "next" after setting the end date in the new card flow
exports.endDateOfNewCardPressed = function(request, response) {
    // validate the date
    var result = validateEndDate(request.params.endDate);
    if (result != null) {
        response.error(result);
        return;
    }

    // must be non-null
    var pendingNewCard = Parse.User.current().get("pendingNewCard");
    pendingNewCard.set("endDate", request.params.endDate);

    pendingNewCard.save(null, {
        success: function(pendingNewCard) {
            response.success(true);
        },
        error: function(pendingNewCard, error) {
            response.error("Could not associate end date with card template due to: " + error);
        }
    });
}

//
// private section
//

// validate the name of a card
exports.validateName = function(request, response) {
    const NAME_MIN_LENGTH = 4;
    const NAME_MAX_LENGTH = 32;

    var name = request.object.get("name")
    
    if (name.length < NAME_MIN_LENGTH || name.length > NAME_MAX_LENGTH) {
        response.error("Name must be between " + NAME_MIN_LENGTH + " and " + NAME_MAX_LENGTH + " characters");
        return;
    }

    response.success();
}

// validate the end date of a card
validateEndDate = function(endDate) {
    const MIN_DELTA_DAYS_FROM_NOW = 0;
    const MAX_DELTA_DAYS_FROM_NOW = 365;

    const now = new Date();
    const delta = (endDate.getTime() - now.getTime()) / (24 * 60 * 60 * 1000);

    if (delta < MIN_DELTA_DAYS_FROM_NOW || delta > MAX_DELTA_DAYS_FROM_NOW) {
        return "End date must be between " + MIN_DELTA_DAYS_FROM_NOW + " and " + MAX_DELTA_DAYS_FROM_NOW + " days from today";
    }

    return null;
}
