Parse.Cloud.beforeSave("CardTemplate", function(request, response) {
    require('cloud/new_card.js').validateName(request, response);
});
