# -*- coding: utf-8 -*-

# TODO: t.co を展開しないと使えない
Plugin.create :filter do

    filter_show_filter do |msgs|
        msgs.each do |m|
            m[:message] = m[:message].gsub /https?:\/\/twitter\.com\/([_a-zA-Z0-9]+?)\/status\/(\d+)/ do
                if $1 && $2
                    require 'twitter'
                    begin
                        status = Twitter.status $2.to_i
                        "(refer to: @" + $1 + ": " + status["text"] + " )"
                    rescue
                        "https://twitter.com/" + $1 + "/status/" + $2
                    end
                else
                    '(refer to: 参照先を取得できませんでした )'
                end
            end
        end
        [msgs]
    end

end
