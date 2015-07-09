const CardTemplate = Parse.Object.extend("CardTemplate");
const CardInstance = Parse.Object.extend("CardInstance");

//
// methods called by users via cloud definitions in main.js
//

// validate the card template keeping in mind it could be at any stage
// of being built up, so some fields are optional
exports.validate = function(request, response) {

    // created by is required
    const createdBy = request.object.get("createdBy");

    if (!createdBy) {
        response.error("CreatedBy is null!");
        return;
    }

    if (createdBy.id != Parse.User.current().id) {
        response.error("CreatedBy != current user");
        return;
    }

    // name is required
    const NAME_MIN_LENGTH = 4;
    const NAME_MAX_LENGTH = 32;

    const name = request.object.get("name");

    if (!name || name.length < NAME_MIN_LENGTH || name.length > NAME_MAX_LENGTH) {
        response.error("Name must be between " + NAME_MIN_LENGTH + " and " + NAME_MAX_LENGTH + " characters");
        return;
    }

    // endDate is optional
    // TODO: how to enforce it can't be removed?
    const MIN_DELTA_DAYS_FROM_NOW = 0;
    const MAX_DELTA_DAYS_FROM_NOW = 365;

    const endDate = request.object.get("endDate")

    if (endDate) {

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

    if (typeCounts) {

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
            if (dict[type]) {
                response.error("Class cannot be included twice: " + type);
                return;
            }

            dict[type] = true;
            numTypeCounts++;
        }

        if (dict[ANY_CLASS_TYPE] && numTypeCounts > 1) {
            response.error("If '" + ANY_CLASS_TYPE + "' is included, no others may be");
            return;
        }
    }

    // isActive is optional
    const isActive = request.object.get("isActive");

    if (isActive) {
        if (!typeCounts || typeCounts.length == 0) {
            response.error("Must have at least one type of class");
            return;
        }
    }

    response.success();
}

exports.beforeDelete = function(request, response) {
    // only allow delete if card is active.  non-active cards get cleaned
    // up by the background job

    if (!request.object.get("isActive")) {
        response.error("Cannot detroy card template due to inactive");
        return;
    }

    // make sure there are no references to the object in card instances
    var query = new Parse.Query(CardInstance);
    query.equalTo("cardTemplate", request.object);

    query.find().then(function(results) {
        if (results.length > 0) {
            response.error("Cannot destroy card template due to reference(s) in card instances");
            return;
        }
        response.success();
    }, function error(error) {
        response.error(error);
    });
}

exports.removeOrphaned = function(request, status) {
    // card templates where isActive is NULL and no user is working on it
    // (that is to say that the user has started working on another since)

    var query = new Parse.Query(CardTemplate);
    query.doesNotExist("isActive");
    query.select("createdBy");
    query.include("createdBy");

    var cardTemplatesToRemove = [];
    query.find().then(function(results) {
        for (var i = 0; i < results.length; i++) {
            var result = results[i];
            var user = result.get("createdBy");
            var userPendingNewCard = user.get("pendingNewCard");
            
            if (!userPendingNewCard || userPendingNewCard.id != result.id) {
                cardTemplatesToRemove.push(result);
            }
        }
        
        return Parse.Object.destroyAll(cardTemplatesToRemove)
    }).then(function() {
        status.success("removed " + cardTemplatesToRemove.length);
    }, function(error) {
        status.error(error);
    });
}
