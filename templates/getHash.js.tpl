var page = require('webpage').create();
page.open("http://%%IP%%/login", function (status) {
	var resultat = page.evaluate(function () {
		var challenge = '%%challenge%%';
		var login = '%%login%%';
		var password = '%%password%%';
		return HMAC_SHA256_MAC(challenge,SHA256_hash(login))+HMAC_SHA256_MAC(challenge,SHA256_hash(password));
	});
	console.log(resultat);
	phantom.exit();
});
