//
// methods called by users via cloud definitions in main.js
//

// user has pressed "next" after setting the name in the new card flow
exports.nameOfNewCardPressed = function(request, response) {
    // validate the name
    var result = validateName(request.params.name);
    if (result != null) {
        response.error(result);
        return;
    }

    // create a new card template and save it
    var CardTemplate = Parse.Object.extend("CardTemplate");
    var cardTemplate = new CardTemplate();

    // helper will be used in promise callbacks below
    associateCardTemplateWithUser = function(cardTemplate, response) {
        Parse.User.current().set("pendingNewCard", cardTemplate);
        Parse.User.current().save(null, {
            success: function(user) {
                response.success(true);
            },
            error: function(user, error) {
                response.error("Could not associate card template with user due to: " + error);
            }
        });
    }

    cardTemplate.save({
        name: request.params.name,
        isActive: false
    }, {
        success: function(cardTemplate) {
            // if the current user has a pending card, delete it
            var pendingNewCard = Parse.User.current().get("pendingNewCard");
            if (pendingNewCard != null) {
                console.log("attempting to remove old card");
                pendingNewCard.destroy({
                    success: function(pendingNewCard) {
                        associateCardTemplateWithUser(cardTemplate, response);
                    },
                    error: function(pendingNewCard, error) {
                        // not fatal
                        console.log("Could not destroy old card due to: " + error);
                        associateCardTemplateWithUser(cardTemplate, response);
                    }
                });
            } else {
                console.log("no old card to remove");
                associateCardTemplateWithUser(cardTemplate, response);
            }
        },
        error: function(cardTemplate, error) {
            response.error("Could not save card template due to: " + error);
        }
    });
}

// user has pressed "next" after setting the end date in the new card flow
exports.endDateOfNewCardPressed = function(request, response) {
}

//
// private section
//

// validate the name of a card
validateName = function(name) {
    const NAME_MIN_LENGTH = 4;
    const NAME_MAX_LENGTH = 32;

    if (name.length < NAME_MIN_LENGTH || name.length > NAME_MAX_LENGTH) {
        return "Name must be between " + NAME_MIN_LENGTH + " and " + NAME_MAX_LENGTH + " characters";
    }

    return null;
}
