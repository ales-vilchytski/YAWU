# encoding: utf-8
module Rbc

  class Rosreestr
      
    def generate_codes(date)
      y, tyd = y_tyd(date)
      
      #15-значные коды (формат см. ниже)
      codes15 = [];

      prefixes15 = ['100', '110', '111', '120', '121', '130', '131', '140', '141']
      prefixes15.each do |prefix|
        codes15 << create15code(prefix, y, tyd)
      end
      
      #невалидные коды, но с правильным формированием даты и контрольной суммы
      invCodes15 = []

      invPrefixes15 = ['102', '453', '105', '501', '600', '190']
      invPrefixes15.each do |prefix| 
        invCodes15 << create15code(prefix, y, tyd)
      end
      
      #16-значные коды (формат см. ниже)
      codes16gkn = [];
      codes19gkn = [];

      services = ['01', '07', '11'];             #код услуги
      subjects = ['01', '14', '21', '51', '79']; #код субъекта
      services.each do |service|
        subjects.each do |subject|
        codes19gkn << create19code(service, subject, y, tyd)
        codes16gkn << create16code(service, subject, y, tyd)
        end
      end

      codes16egrp = [];
      codes19egrp = [];

      services = ['01', '04', '07', '10', '51', '56', '59']; #код услуги
      subjects = ['01', '02', '08', '11', '14', '17', '26', '33', '51', '79', '88']; #код субъекта
      services.each do |service|
        subjects.each do |subject|
        codes19egrp << create19code(service, subject, y, tyd)
        codes16egrp << create16code(service, subject, y, tyd)
        end
      end

      #невалидные коды, но с правильным формированием даты и контрольной суммы
      invCodes16 = [];
      invCodes19 = [];

      invServices = ['09', '13', '12']; #код услуги
      invSubjects = ['01', '02', '74']; #код субъекта
      invServices.each do |service|
        invSubjects.each do |subject|
        invCodes19 << create19code(service, subject, y, tyd)
        invCodes16 << create16code(service, subject, y, tyd)
        end
      end
      
      return { 
        valid_codes15: codes15, 
        invalid_codes15: invCodes15,
        
        valid_codes19_egrp: codes19egrp,
        valid_codes19_gkn: codes19gkn,
        invalid_codes19: invCodes19,
        
        valid_codes16_egrp: codes16egrp,
        valid_codes16_gkn: codes16gkn,
        invalid_codes16: invCodes16,
      }
    end
    
    def generate_codes_txt(date)
      y, tyd = y_tyd(date)
      codes = generate_codes(date)
            
      return %Q{Информационный ресурс (AZRYBBBBBBBDDDС (15) )
100 3    0000000 001 1
 11 год          366 к.р.(сумма всех цифр % 10)
 2
 3
 4
день года должен быть не ранее 30 дней от текущего

Примеры:
130300000000120 - заявка просрочена
#{create15code('100', y, tyd)}
#{create15code('111', y, tyd)}
#{create15code('110', y, tyd)}
#{create15code('120', y, tyd)}
#{create15code('130', y, tyd)}


Кадастр и картография, учётные системы SSFFBBBNNNNNDDDС (16) или SSFFRRRBBBNNNNNDDDС (19)
01 		01 		(000) 3   0000000 001 1	 
код усл	код суб      год	  	  366 к.р. (сумма всех цифр % 10)

Примеры:
#{create16code('01', '01', y, tyd)} -> #{create19code('01', '01', y, tyd)}
#{create16code('01', '02', y, tyd)} - заявка просрочена
#{create16code('04', '88', y, tyd)} - невозможна оплата для юрлиц
#{create16code('11', '79', y, tyd)}
#{create16code('56', '01', y, tyd)}
#{create16code('59', '33', y, tyd)} - невозможна оплата для юрлиц


Случайные валидные коды:
#{codes[:valid_codes15].join("\n")}

16- и 19-значные коды эквивалентны
#{codes[:valid_codes16_egrp].join("\n")}
#{codes[:valid_codes16_gkn].join("\n")}

#{codes[:valid_codes19_egrp].join("\n")}
#{codes[:valid_codes19_gkn].join("\n")}


Случайные невалидные коды:
#{codes[:invalid_codes15].join("\n")}

#{codes[:invalid_codes16].join("\n")}

#{codes[:invalid_codes19].join("\n")}}

    end
 
    private
    
    def y_tyd(date)
      tyd = date.yday.to_s
      tyd = '000'.slice(0, 3 - tyd.size) + tyd
      y = (date.year % 10).to_s
      return [y, tyd]
    end
  
    def append_checksum1!(str)
      sum = 0
      str.to_s.each_char { |dig| sum += dig.to_i }
      sum = sum % 10
      str += sum.to_s
    end

    def rand_between(min, max)
      min + rand(max - min)
    end

    def create15code(prefix, y, tyd)
      append_checksum1!(prefix + y + rand_between(1000000, 1000010).to_s + tyd)
    end

    def create16code(service, subject, y, tyd)
      append_checksum1!(service + subject + y + rand_between(1000000, 1000010).to_s + tyd)
    end

    def create19code(service, subject, y, tyd)
      append_checksum1!(service + subject + '000' + y + rand_between(1000000, 1000010).to_s + tyd)
    end
  
  end

end