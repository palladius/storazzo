# Ric common stuff! :)
#
# Usage:
#      include Storazzo::Common  (def to def)
# or
#      extend Storazzo::Common   (def to def self.XX)
#
=begin
  Emoji to copy:
  ๐ ๐  ๐ โ  ๐ ๐ค ๐ ๐ค ๐ค ๐ค ๐ค ๐ ๐ ๐ ๐ค โ ๐ค ๐ ๐ ๐คฒ ๐ ๐ ๐ค ๐ค ๐
๐ ๐ ๐ ๐
โบ โป ๐ ๐ ๐ ๐ ๐ ๐ ๐ ๐ ๐ ๐คฃ ๐คฉ ๐คช ๐ฅณ ๐ ๐ ๐ ๐ค  ๐คก ๐ค ๐ค ๐ค kiss
๐ ๐ ๐ ๐ flirting
๐ ๐ค ๐ ๐ฅฐ ๐คค ๐ ๐ ๐ ๐ neutral
๐ถ ๐ ๐ ๐ ๐ค ๐คจ ๐ง hush
๐คญ ๐คซ ๐ฏ ๐ค ๐ ๐ ๐ ๐ณ ๐ ๐คฅ ๐ฅด shocked
๐ฎ ๐ฒ ๐คฏ tired
๐ฉ ๐ซ ๐ฅฑ ๐ช ๐ด ๐ต sad
โน ๐ฆ ๐ ๐ฅ ๐ cry
๐ข ๐ญ sick
๐คข ๐คฎ ๐ท ๐ค ๐ค ๐ฅต ๐ฅถ fear
๐ฅบ ๐ฌ ๐ ๐ฐ ๐จ ๐ฑ angry
๐ ๐  ๐ก ๐ค ๐ฃ ๐ง ๐คฌ ๐ธ ๐น ๐บ ๐ป ๐ผ ๐ฝ ๐พ ๐ฟ ๐ ๐ ๐ ๐
[see Animal Emoji ๐ฐ] gesture
๐คฆ ๐คท ๐ ๐ ๐ ๐ ๐ ๐ ๐ ๐ activity
๐ฏ ๐ ๐บ ๐คณ ๐ ๐ ๐ ๐ง ๐ง ๐ง ๐ง ๐ฐ ๐คฐ ๐คฑ faces
๐ถ ๐ง ๐ฆ ๐ง ๐ฉ ๐จ ๐ง ๐ง ๐ง ๐ด ๐ต ๐ค ๐ฅ ๐ช ๐ซ ๐ฌ ๐ญ ๐ฑ ๐ณ ๐ฒ ๐ง ๐ธ ๐คด ๐ ๐คถ disabled
๐ง ๐ฆป ๐ฆฎ ๐ฆฏ ๐ฆบ ๐ฆผ ๐ฆฝ ๐ฆพ ๐ฆฟ ๐คต ๐ฎ ๐ท ๐ ๐ ๐ด ๐ต ๐ฆธ ๐ฆน ๐ง ๐ง ๐ง ๐ง ๐ง ๐ง ๐ง ๐ผ ๐ฟ ๐ป ๐น ๐บ ๐ฝ ๐พ ๐ธ ๐ โ  ๐ฑ ๐ง  ๐ฆด ๐ ๐ ๐ ๐ ๐ ๐ข ๐ ๐ฆท ๐ฆต ๐ฆถ ๐ญ ๐ฌ ๐ญ ๐ฌ ๐จ ๐ฉ ๐ช ๐ซ ๐ฐ ๐ฑ ๐ฎ ๐ฏ ๐ฃ ๐ค ๐ฅ ๐ฆ ๐ง ๐ฆ ๐ง ๐ข ๐ซ ๐ค ๐จ ๐ฅ ๐ช ๐ฒ ๐ฅ ๐ก ๐ฉ ๐ฏ ๐ ๐ฐ ๐ฒ
=end
require_relative 'colors'
require 'pry'

module Storazzo::Common
  include Storazzo::Colors

  def deb(s)
    puts "[DEB๐] #{yellow(s)}" if _debug_true # $DEBUG
  end

  # this has a yield
  def if_deb?()
    if _debug_true # $DEBUG
      deb "== yield START =="
      yield
      deb "== yield END =="
    end
  end

  def warn(s)
    puts "[Wโ ๏ธRN] #{azure(s)}"
  end

  def err(str)
    puts "[ERR๐] #{red(s)}" # โ
  end

  def bug(s)
    puts "[๐] #{gray s}"
  end

  def pverbose(is_verbose, str)
    # puts "[V๐RB๐S๐] #{gray str}"
    puts "[๐ฆ๐๐๐๐๐ท๐ธ๐ฆ๐ฆ๐ฆ] #{gray str}" # insects: http://xahlee.info/comp/unicode_insects.html
  end

  def ppp(complex_object_to_colorize)
    # TODO i need to learn to return without printing..
    Pry::ColorPrinter.pp(complex_object_to_colorize)
  end

  def fatal(s)
    raise "[F๐TAL] #{red s}"
  end

  def mac?
    `uname`.chomp == 'Darwin'
  end

  def linux?
    `uname`.chomp == 'Linux'
  end

  private

  def _debug_true
    $DEBUG or ENV["DEBUG"] == 'true'
  end

  #    puts "[DEBUG ENABLED!]" if _debug_true
end
