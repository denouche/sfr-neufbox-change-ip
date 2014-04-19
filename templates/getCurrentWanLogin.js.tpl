var page = require('webpage').create();

phantom.addCookie({
    'name': 'sid',
    'value': '%%challenge%%',
    'domain': '%%IP%%',
    'path': '/'
});

page.open("http://%%IP%%/network/wan", function (status) {
	var login = page.evaluate(function () {
        return $('#ppp_login').val();
	});
	console.log(login);
	phantom.exit();
});
