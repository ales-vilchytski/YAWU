require 'paperclip/media_type_spoof_detector'

# Workaround for bug https://github.com/thoughtbot/paperclip/issues/1429
# Turns Off paperclip content-type spoof validation
# TODO !!! UNSECURE !!!
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
