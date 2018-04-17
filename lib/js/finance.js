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

var DATE_RE = /^\d{4}\-\d{2}\-\d{2}::\s+/;
var PRICE_RE = /[\-\$\d,\.]+$/;
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
            result += ">>>ERR>>>" + ln + ">>>ERR>>>\n";
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
            if (price == null || price.length != 1) {
                result += ">>>ERR>>>\t" + parts[j];
                continue;
            } else {
                price = price[0];
                name = parts[j].replace(price, '');
                if (price.indexOf('$') != -1) {
                    price = price.replace('$', '');
                } else {
                    price = parseFloat(String(price).replace(',', '.')) / numToDollarRate;
                    price = Math.round(price * 100) / 100;
                    price = String(price).replace('.', ',');
                }
            }
            var category = categoriesMap[name] || '';
            name = namingMap[name] || name;

            if (name.indexOf('М') == name.length - 1 && name != 'М') {
                name = name.substr(0, name.length - 1);
                category = categoriesMap[name] || '';
                name = namingMap[name] || name;
                result += SEP + [name + ",М", price, category].join(SEP) + '\n';
                result += SEP + [name, String(parseFloat(price.replace(',', '.')) * -1).replace('.', ','), 'МММ'].join(SEP) + '\n';
            } else {
                result += SEP + [name, price, category].join(SEP) + '\n';
            }
        }
    }

    return result;
}
