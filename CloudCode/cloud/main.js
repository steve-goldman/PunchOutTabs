Parse.Cloud.define("nameOfNewCardNextPressed", function(request, response) {
    require('cloud/new_card.js').nameOfNewCardPressed(request, response);
});
