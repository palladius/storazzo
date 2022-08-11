# frozen_string_literal: true

# Ric common stuff! :)
#
# Usage:
#      include Storazzo::Common  (def to def)
# or
#      extend Storazzo::Common   (def to def self.XX)
#
#   Emoji to copy:
#   👍 👎  👌 ✌  👋 🤝 👏 🤘 🤟 🤙 🤏 🙌 🙏 🖖 🤞 ✋ 🤚 🖐 🖑 🤲 👐 👊 🤛 🤜 🖕
# 👈 👉 👆 👇
# ☺ ☻ 😃 😄 😅 😆 😊 😎 😇 😈 😏 🤣 🤩 🤪 🥳 😁 😀 😂 🤠 🤡 🤑 🤓 🤖 kiss
# 😗 😚 😘 😙 flirting
# 😉 🤗 😍 🥰 🤤 😋 😛 😜 😝 neutral
# 😶 🙃 😐 😑 🤔 🤨 🧐 hush
# 🤭 🤫 😯 🤐 😌 😖 😕 😳 😔 🤥 🥴 shocked
# 😮 😲 🤯 tired
# 😩 😫 🥱 😪 😴 😵 sad
# ☹ 😦 😞 😥 😟 cry
# 😢 😭 sick
# 🤢 🤮 😷 🤒 🤕 🥵 🥶 fear
# 🥺 😬 😓 😰 😨 😱 angry
# 😒 😠 😡 😤 😣 😧 🤬 😸 😹 😺 😻 😼 😽 😾 😿 🙀 🙈 🙉 🙊
# [see Animal Emoji 🐰] gesture
# 🤦 🤷 🙅 🙆 🙋 🙌 🙍 🙎 🙇 🙏 activity
# 👯 💃 🕺 🤳 💇 💈 💆 🧖 🧘 🧍 🧎 👰 🤰 🤱 faces
# 👶 🧒 👦 👧 👩 👨 🧑 🧔 🧓 👴 👵 👤 👥 👪 👫 👬 👭 👱 👳 👲 🧕 👸 🤴 🎅 🤶 disabled
# 🧏 🦻 🦮 🦯 🦺 🦼 🦽 🦾 🦿 🤵 👮 👷 💁 💂 🕴 🕵 🦸 🦹 🧙 🧚 🧜 🧝 🧞 🧛 🧟 👼 👿 👻 👹 👺 👽 👾 🛸 💀 ☠ 🕱 🧠 🦴 👁 👀 👂 👃 👄 🗢 👅 🦷 🦵 🦶 💭 🗬 🗭 💬 🗨 🗩 🗪 🗫 🗰 🗱 🗮 🗯 🗣 🗤 🗥 🗦 🗧 💦 💧 💢 💫 💤 💨 💥 💪 🗲 🔥 💡 💩 💯 🔟 🔰 🕲
require_relative 'colors'
require 'pry'

module Storazzo
  module Common
    include Storazzo::Colors

    def deb(s)
      # useless: put logic in _debug_true() # return if ENV['RUBYOPT'] == "-W0"
      puts "[DEB👀] #{yellow(s)}" if _debug_true # $DEBUG
    end

    # this has a yield
    def if_deb?
      if _debug_true # $DEBUG
        deb '== yield START =='
        yield
        deb '== yield END =='
      end
    end

    def warn(s)
      puts "[W⚠️RN] #{azure(s)}"
    end

    def err(_str)
      puts "[ERR👎] #{red(s)}" # ⛔
    end

    def bug(s)
      puts "[🐛] #{gray s}"
    end

    def pverbose(_is_verbose, str)
      # puts "[V📚RB💀S📚] #{gray str}"
      return if ENV['RUBYOPT'] == '-W0'

      puts "[🦋🐛🐝🐞🐜🕷🕸🦂🦗🦟] #{gray str}" # insects: http://xahlee.info/comp/unicode_insects.html
    end

    def ppp(complex_object_to_colorize)
      # TODO: i need to learn to return without printing..
      Pry::ColorPrinter.pp(complex_object_to_colorize)
    end

    def fatal(s)
      raise "[F💀TAL] #{red s}"
    end

    def mac?
      `uname`.chomp == 'Darwin'
    end

    def linux?
      `uname`.chomp == 'Linux'
    end

    private

    def _debug_true
      return false if ENV['RUBYOPT'] == '-W0'

      $DEBUG or ENV['DEBUG'] == 'true' # but FALSE isor _debug_true
    end

    #    puts "[DEBUG ENABLED!]" if _debug_true
  end
end
