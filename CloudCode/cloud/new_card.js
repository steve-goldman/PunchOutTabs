//
// methods called by users via cloud definitions in main.js
//

// validate the name of a card
exports.validateName = function(request, response) {
    // name is required
    const NAME_MIN_LENGTH = 4;
    const NAME_MAX_LENGTH = 32;

    const name = request.object.get("name")
    
    if (name.length < NAME_MIN_LENGTH || name.length > NAME_MAX_LENGTH) {
        response.error("Name must be between " + NAME_MIN_LENGTH + " and " + NAME_MAX_LENGTH + " characters");
        return;
    }

    // endDate is optional
    // TODO: how to enforce it can't be removed?
    const MIN_DELTA_DAYS_FROM_NOW = 0;
    const MAX_DELTA_DAYS_FROM_NOW = 365;

    const endDate = request.object.get("endDate")
    if (endDate != null) {
        const now = new Date();
        const delta = (endDate.getTime() - now.getTime()) / (24 * 60 * 60 * 1000);

        if (delta < MIN_DELTA_DAYS_FROM_NOW || delta > MAX_DELTA_DAYS_FROM_NOW) {
            response.error("End date must be between " + MIN_DELTA_DAYS_FROM_NOW + " and " + MAX_DELTA_DAYS_FROM_NOW + " days from today");
            return;
        }
    }

    response.success();
}
