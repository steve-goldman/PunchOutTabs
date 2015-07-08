Parse.Cloud.beforeSave("CardTemplate", function(request, response) {
    require('cloud/card_template.js').validate(request, response);
});
