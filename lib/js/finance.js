var categoriesMap = {
    "о": "Обеды",
    "o": "Обеды",
    "прод": "Продукты",
    "ЗП": "ЗП",
    "зп": "ЗП",
    "бенз": "Машина",
    "аренды": "Платежи"
};

var namingMap = {
    "о": "обед",
    "o": "обед",
    "прод": "продукты"
};

var currencyMap = [
    '', // BYN
    '$',
    '€'
];

var DATE_RE = /^\d{4}\-\d{2}\-\d{2}::\s+/;
var PRICE_RE = /([$€]?)([\-\$\d,\.]+)$/;
var SEP = '\t';

function parseStringToTable(input, numToDollarRate) {
    numToDollarRate = parseFloat(String(numToDollarRate).replace(',', '.')) || 2;
    var result = '';
    var lines = input.split("\n");
    for (var i = lines.length - 1; i >= 0; --i) {
        var ln = lines[i];
        var dt = DATE_RE.exec(ln);
        if (ln.trim() == '') {
            continue;
        } else if (dt == null || dt.length != 1) {
            result += ">>>ERR_DATE>>>" + ln + ">>>ERR_DATE>>>\n";
            continue;
        } else {
            ln = ln.replace(DATE_RE, '');
            dt = dt[0].replace('::', '');
        }
        var parts = ln.split(/\s+/);
        result += dt + '\n';
        for (var j = 0; j < parts.length; ++j) {
            if (parts[j].match(/^\s*$/)) { continue; }
            var price = PRICE_RE.exec(parts[j]);
            var name = '';
            if (price == null || (price.length < 2 || price.length > 3)) {
                result += ">>>ERR_PRICE(" + string(price) + ">>>\t" + parts[j];
                continue;
            } else {
                var price_val = price.length == 2 ? price[1] : price[2];
                var currency = price.length == 2 ? '' : price[1];
                name = parts[j].replace(currency + price_val, '');
                price = parseFloat(String(price_val).replace(',', '.'));
                price = Math.round(price * 100) / 100;
                price = String(price).replace('.', ',');
            }
            name = namingMap[name] || name;
            result += formatPrice(currency, price, name);
        }
    }

    return result;
}

function formatPrice(currency, price, name) {
    var negative_price = String(parseFloat(price.replace(',', '.')) * -1).replace('.', ',');
    var result = '';
    var category = categoriesMap[name] || '';

    if (name.indexOf('М') == name.length - 1 && name != 'М') {
        name = name.substr(0, name.length - 1);
        name = namingMap[name] || name;
        result += SEP + [name + ",М", priceArray(currency, price).join(SEP), category].join(SEP) + '\n';
        result += SEP + [name, priceArray(currency, negative_price).join(SEP), 'МММ'].join(SEP) + '\n';
    } else {
        result += SEP + [name, priceArray(currency, price).join(SEP), category].join(SEP) + '\n';
    }
    return result;
}

function priceArray(currency, price) {
    return currencyMap.map(function(curr) {
        return curr === currency ? price : null
    });
}
