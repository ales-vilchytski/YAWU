# encoding: utf-8
require 'lib/java_util'

module Rbc

  class Gibdd
    
    def initialize
      @_gibddUtil = JavaUtil::JSEvaluator.new('lib/js/gibddUtil.js')
    end
    
    def generate_new_rand_uin()
      uin = [
        '18810',
        rand(0..4),
        rand(10..99),
        '14', #TODO год не ранее 14 и не позднее текущего
        rand(0.1e+9..0.9e+9).to_i,
      ].join
      return uin + calc_checksum(uin)
    end
    
    def generate_old_rand_uin()
      num_post = [
        rand(10..99),
        2.times.map { rand(0x0410..0x042F) }.pack('UU'),
        rand(0.1e+6..0.9e+8).to_i,
      ].join
      date = ((Date.today - 3.years) + (360 * 3 * rand)).strftime("%d%m%Y")
      return @_gibddUtil.generateGibddUin(num_post, date)
    end
      
    def calc_checksum(uin)
      return @_gibddUtil.calcGibddCheckSum(uin)
    end
    
    def parse_old_uin(uin)
      res = @_gibddUtil.parseGibddUin(uin)
      return {
        num_post: res.get('np', nil),
        date_post: res.get('dp', nil)
      }
    end
    
  end

end