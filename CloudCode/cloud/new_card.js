//
// methods called by users via cloud definitions in main.js
//

// validate the name of a card
exports.validateName = function(request, response) {
    // name is required
    const NAME_MIN_LENGTH = 4;
    const NAME_MAX_LENGTH = 32;

    const name = request.object.get("name")

    if (name == null) {
        response.error("Name is null!");
        return;
    }
    
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

    // typeCounts is optional
    // (note: it can be removed if the user removes the only type count)
    const MIN_COUNT_FOR_TYPECOUNT = 1;
    const MAX_COUNT_FOR_TYPECOUNT = 999;
    const ANY_CLASS_TYPE = "Any Class";

    const typeCounts = request.object.get("typeCounts");

    if (typeCounts != null) {

        var dict = {};
        var numTypeCounts = 0;

        for (var i = 0; i < typeCounts.length; i++) {

            var tokens = typeCounts[i].split(':');

            if (tokens.length != 2) {
                response.error("The type of class must not contain the : character");
                return;
            }

            var count = parseInt(tokens[0]);
            if (isNaN(count) || count < MIN_COUNT_FOR_TYPECOUNT || count > MAX_COUNT_FOR_TYPECOUNT) {
                response.error("Number of classes must be between " + MIN_COUNT_FOR_TYPECOUNT + " and " + MAX_COUNT_FOR_TYPECOUNT);
                return;
            }

            var type = tokens[1];
            if (dict[type] != null) {
                response.error("Class cannot be included twice: " + type);
                return;
            }

            dict[type] = true;
            numTypeCounts++;
        }

        if (dict[ANY_CLASS_TYPE] != null && numTypeCounts > 1) {
            response.error("If '" + ANY_CLASS_TYPE + "' is included, no others may be");
            return;
        }
    }

    // isActive is optional
    const isActive = request.object.get("isActive");

    if (isActive) {
        if (typeCounts == null || typeCounts.length == 0) {
            response.error("Must have at least one type of class");
            return;
        }
    }

    response.success();
}
