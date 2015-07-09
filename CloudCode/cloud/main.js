Parse.Cloud.beforeSave(Parse.User, function(request, response) {
    require('cloud/user.js').validate(request, response);
});

Parse.Cloud.beforeSave("CardTemplate", function(request, response) {
    require('cloud/card_template.js').validate(request, response);
});

Parse.Cloud.beforeDelete("CardTemplate", function(request, response) {
    require('cloud/card_template.js').beforeDelete(request, response);
});

Parse.Cloud.job("removeOrphanedCardTemplates", function(request, response) {
    require('cloud/card_template.js').removeOrphaned(request, response);
});
