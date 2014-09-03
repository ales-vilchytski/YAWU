var mask64 = String('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЬЭЮЯ'); //base64
var mask_dig = '0123456789';
var mask_rus = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЭЮЯ----Ъ--Ы-----Ь';
var mask_eng = 'A-B--E---K-MHO-PCTY-X-------DFGIJLNQRSUVWZ';
var days = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]; //day year
var days2 = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335]; //leap year
var cy = Number(new Date().getFullYear());

/**
 * Генерация УИН для ГИБДД, выдранная из услуги с ПРОМа
 *   
 * @param num {String} - номер постановления
 * @param date {String} - дата постановления в формате ДД[.\/-]ММ[.\/-]ГГГГ[.\/-]
 * @returns {String}
 */
function generateGibddUin(num, date) {
    
    var data = String(date);
    var dateArr = /(\d{2})[\.\\\/\-]?(\d{2})[\.\\\/\-]?(\d{4})/.exec(data);
    var dy = Number(dateArr[1]);
    var mn = Number(dateArr[2]);
    var yr = Number(dateArr[3]);
    var ss = 0;
    if ((yr % 4 == 0) && (yr != 2100)) {
        ss = Number(days2[mn - 1]) + Number(dy);
    } else {
        ss = Number(days[mn - 1]) + Number(dy);
    }
    ss = 10 * ss + yr % 10;
    var sd = mask64.charAt(Math.floor(Number(ss / 64))) + mask64.charAt(ss % 64),
        standart = 'ZZZZZZZZZZZZ',
        prevValue = String(num);
    prevValue = prevValue + standart.substr(0, 12 - prevValue.length);
    account = String('18810' + sd + prevValue);
    
    return account = account + calcGibddCheckSum(account);
}

/**
 * Расчёт контрольного разряда УИН (20-ая цифра). Согласно спецификации, 
 * подходит как для старых УИНов, так и для новых.
 *  
 * @param uin {String} - 19 цифр УИНа, по которым нужно рассчитать контрольную сумму
 * @returns {String}
 */
function calcGibddCheckSum(uin) {
    
    var j, k, fl = -1, cc, sm = 0, tmp = '';
    for (j = 0; j < uin.length; j++) {
        cc = uin.charAt(j);
        fl = mask_dig.indexOf(cc);
        if (fl == -1) {
            fl = mask_rus.indexOf(cc);
            if (fl == -1) {
                fl = mask_eng.indexOf(cc);
            }
            fl++;
            fl = fl % 10;
        }
        tmp = tmp + String(fl);
    }
    //var tmp-for calc check    
    for (j = 0; j < 19; j++) {
        cc = Number(tmp.charAt(j));
        if (j > 9) {
            k = j - 9;
        } else {
            k = j + 1;
        }
        sm = sm + cc * k;
    }
    sm = sm % 11;
    if (sm == 10) {
        sm = 0;
        for (j = 0; j < 19; j++) {
            cc = Number(tmp.charAt(j));
            if (j < 8) {
                k = j + 3;
            } else {
                k = j - 7;
                if (k == 11) {
                    k = 1;
                }
            }
            sm = sm + cc * k;
        }
        sm = sm % 11;
        if (sm == 10) {
            sm = 0;
        }
    }
    return String(sm)    
}

/**
 * Парсинг "старых" УИН ГИБДД с номером и датой постановления
 * Выдрано из услуги с прома.
 * 
 * @param uin {String} - старый УИН
 * @returns {Object} - номер (np) и дата (dp) постановления
 */
function parseGibddUin(uin) {
    var np = uin.substr(7, 12);
    var dp = uin.substr(5, 2);
    var mn;
    var dy;
    var yrr;
    var dp_10;
    var m = np.length - 1;
    while ((np.charAt(m) == 'Z') || (np.charAt(m) == 'z')) {
        m--;
    }
    np = np.substr(0, m + 1);
    dp_10 = Number(mask64.indexOf(dp.charAt(0))) * 64 + Number(mask64.indexOf(dp.charAt(1)));
    yrr = dp_10 % 10;
    m = cy - 9;
    while (m % 10 != yrr) {
        m++;
    }
    yrr = m;
    dp_10 = Math.floor(Number(dp_10 / 10));
    m = 1;
    if (yrr % 4 == 0) {
        while ((m < 12) && (dp_10 > days2[m])) {
            m++;
        }
        mn = m;
        dy = dp_10 - days2[m - 1];
    } else {
        while ((m < 12) && (dp_10 > days[m])) {
            m++;
        }
        mn = m;
        dy = dp_10 - days[m - 1];
    }
    if (dy < 10) {
        dp = '0';
    } else {
        dp = '';
    }
    dp = dp + String(dy) + '.';
    if (mn < 10) {
        dp = dp + '0';
    }
    dp = dp + String(mn) + '.';
    if ((yrr % 100) < 10) {
        dp = dp + '0';
    }
    dp = dp + String(yrr % 100);
    return { 'np': np, 'dp': dp };
}
