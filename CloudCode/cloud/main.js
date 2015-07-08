Parse.Cloud.beforeSave("CardTemplate", function(request, response) {
    require('cloud/new_card.js').validateName(request, response);
});

Parse.Cloud.define("endDateOfNewCardNextPressed", function(request, response) {
    require('cloud/new_card.js').endDateOfNewCardPressed(request, response);
});
