Parse.Cloud.beforeSave("CardTemplate", function(request, response) {
    require('cloud/card_template.js').validateName(request, response);
});
